//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation


class GappleMailTableView: NSObject {
    
    override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let cls: AnyClass = NSClassFromString("MailTableView")!
            let originalSelector: Selector = Selector(Kbind.KEY_DOWN.rawValue)
            let swizzledSelector: Selector = Selector(Kbind.SWIZZLE.rawValue)
            let originalMethod: Method = class_getInstanceMethod(cls, originalSelector)
            let swizzledMethod: Method = class_getInstanceMethod(self, swizzledSelector)
            class_addMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            class_replaceMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            NSLog("GappleMailTableView Initialized")
        }
    }
        
    dynamic func swizzleKeyDown(event: NSEvent) {
        let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
        let msgViewer = self.performSelector(Selector("delegate")).takeUnretainedValue().performSelector(Selector("delegate")).takeUnretainedValue()
        switch GappleUtils.instance.getChar(event) {
            case "#":
                msgViewer.performSelector(Selector(Kbind.DELETE.rawValue), withObject: nil)
            case "/":
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.F.rawValue, andMask: CGEventFlags.MaskCommand))
            case "?":
                let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.F.rawValue, andMask: flags))
            case "!":
                msgViewer.performSelector(Selector(Kbind.JUNK.rawValue), withObject: nil)
            case "a" where hasControl == true:
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.FIVE.rawValue, andMask: CGEventFlags.MaskCommand))
            case "a":
                msgViewer.performSelector(Selector(Kbind.REPLY_ALL.rawValue), withObject: nil)
            case "c":
                msgViewer.performSelector(Selector(Kbind.COMPOSE.rawValue), withObject: nil)
            case "d" where hasControl == true:
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.THREE.rawValue, andMask: CGEventFlags.MaskCommand))
            case "e":
                msgViewer.performSelector(Selector(Kbind.ARCHIVE.rawValue), withObject: nil)
            case "f":
                msgViewer.performSelector(Selector(Kbind.FORWARD.rawValue), withObject: nil)
            case "g":
                self.swizzleKeyDown(event)
            case "i" where hasControl == true:
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.ONE.rawValue, andMask: CGEventFlags.MaskCommand))
            case "I":
                msgViewer.performSelector(Selector(Kbind.READ.rawValue), withObject: nil)
            case "j":
                let nsEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, Kcode.ARROW_DOWN.rawValue, true)!)
                self.swizzleKeyDown(nsEvent)
            case "J":
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.ARROW_DOWN.rawValue, andMask: CGEventFlags.MaskShift))
            case "k":
                let newEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, Kcode.ARROW_UP.rawValue, true)!)
                self.swizzleKeyDown(newEvent)
            case "K":
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.ARROW_UP.rawValue, andMask: CGEventFlags.MaskShift))
            case "o":
                msgViewer.performSelector(Selector(Kbind.OPEN.rawValue), withObject: nil)
            case "r":
                msgViewer.performSelector(Selector(Kbind.REPLY.rawValue), withObject: nil)
            case "s" where hasControl == true:
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.FOUR.rawValue, andMask: CGEventFlags.MaskCommand))
            case "s":
                msgViewer.performSelector(Selector(Kbind.TOGGLE_FLAG.rawValue), withObject: nil)
            case "t" where hasControl == true:
                self.swizzleKeyDown(GappleUtils.instance.maskKey(withKeyCode: Kcode.TWO.rawValue, andMask: CGEventFlags.MaskCommand))
            case "U":
                msgViewer.performSelector(Selector(Kbind.UNREAD.rawValue), withObject: nil)
            case "y":
                msgViewer.performSelector(Selector(Kbind.ARCHIVE.rawValue), withObject: nil)
            default:
                self.swizzleKeyDown(event)
        }
    }
}
