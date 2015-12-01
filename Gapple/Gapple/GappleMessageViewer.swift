//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation


class GappleMessageViewer: NSObject {
    
    override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let cls: AnyClass = NSClassFromString("MessageViewer")!
            let originalSelector = Selector(Kbind.KEY_DOWN.rawValue)
            let swizzledSelector = Selector(Kbind.SWIZZLE.rawValue)
            let originalMethod = class_getInstanceMethod(cls, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            class_addMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            class_replaceMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            NSLog("GappleMessageViewer Initialized")
        }
    }
    
    dynamic func swizzleKeyDown(event: NSEvent) {
        NSLog("overrideMessagesKeyDown")
        let hasCommand: Bool = event.modifierFlags.contains(.CommandKeyMask)
        let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
        switch GappleUtils.instance.getChar(event) {
        case "#":
            self.performSelector(Selector(Kbind.DELETE.rawValue), withObject: nil)
        case "/":
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.F.rawValue, andMask: CGEventFlags.MaskCommand))
        case "?":
            let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.F.rawValue, andMask: flags))
        case "a" where hasControl == true:
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.FIVE.rawValue, andMask: CGEventFlags.MaskCommand))
        case "a":
            self.performSelector(Selector(Kbind.REPLY_ALL.rawValue), withObject: nil)
        case "c":
            self.performSelector(Selector(Kbind.COMPOSE.rawValue), withObject: nil)
        case "d" where hasControl == true:
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.THREE.rawValue, andMask: CGEventFlags.MaskCommand))
        case "e":
            self.performSelector(Selector(Kbind.ARCHIVE.rawValue), withObject: nil)
        case "f" where hasCommand == true:
            self.swizzleKeyDown(event)
        case "f":
            self.performSelector(Selector(Kbind.FORWARD.rawValue), withObject: nil)
        case "i" where hasControl == true:
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.ONE.rawValue, andMask: CGEventFlags.MaskCommand))
        case "r":
            self.performSelector(Selector(Kbind.REPLY.rawValue), withObject: nil)
        case "s" where hasControl == true:
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.FOUR.rawValue, andMask: CGEventFlags.MaskCommand))
        case "s":
            self.performSelector(Selector(Kbind.TOGGLE_FLAG.rawValue), withObject: nil)
        case "t" where hasControl == true:
            self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.TWO.rawValue, andMask: CGEventFlags.MaskCommand))
        case "y":
            self.performSelector(Selector(Kbind.ARCHIVE.rawValue), withObject: nil)
        default:
            self.swizzleKeyDown(event)
        }
    }
}
