//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation


class Gapple: NSObject {
    
    override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            var cls: AnyClass = NSClassFromString("MailTableView")!
            var originalSelector: Selector = Selector("keyDown:")
            var swizzledSelector: Selector = Selector("overrideMailKeyDown:")
            var originalMethod: Method = class_getInstanceMethod(cls, originalSelector)
            var swizzledMethod: Method = class_getInstanceMethod(self, swizzledSelector)
            class_addMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            class_replaceMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            NSLog("token")
            cls = NSClassFromString("MessageViewer")!
            originalSelector = Selector("keyDown:")
            swizzledSelector = Selector("overrideMessagesKeyDown:")
            originalMethod = class_getInstanceMethod(cls, originalSelector)
            swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            class_addMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            class_replaceMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            NSLog("token")
        }
    }
    
    dynamic func overrideMailKeyDown(event: NSEvent) {
        NSLog("overrideMailKeyDown")
        let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
        let msgViewer = self.performSelector(Selector("delegate")).takeUnretainedValue().performSelector(Selector("delegate")).takeUnretainedValue()
        switch getChar(event) {
        case "#":
            msgViewer.performSelector("deleteMessages:", withObject: nil)
        case "/":
            self.overrideMailKeyDown(maskKey(withKeyCode: 3, andMask: CGEventFlags.MaskCommand))
        case "?":
            let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
            self.overrideMailKeyDown(maskKey(withKeyCode: 3, andMask: flags))
        case "!":
            msgViewer.performSelector("markAsJunkMail:", withObject: nil)
        case "a" where hasControl == true:
            self.overrideMailKeyDown(maskKey(withKeyCode: 23, andMask: CGEventFlags.MaskCommand))
        case "a":
            msgViewer.performSelector("replyAllMessage:", withObject: nil)
        case "c":
            msgViewer.performSelector("showComposeWindow:", withObject: nil)
        case "d" where hasControl == true:
            self.overrideMailKeyDown(maskKey(withKeyCode: 20, andMask: CGEventFlags.MaskCommand))
        case "e":
            msgViewer.performSelector("archiveMessages:", withObject: nil)
        case "f":
            msgViewer.performSelector("forwardMessage:", withObject: nil)
        case "g":
            self.overrideMailKeyDown(event)
        case "i" where hasControl == true:
            self.overrideMailKeyDown(maskKey(withKeyCode: 18, andMask: CGEventFlags.MaskCommand))
        case "I":
            msgViewer.performSelector("markAsRead:", withObject: nil)
        case "j":
            let nsEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, 125, true)!)
            self.overrideMailKeyDown(nsEvent)
        case "J":
            self.overrideMailKeyDown(maskKey(withKeyCode: 125, andMask: CGEventFlags.MaskShift))
        case "k":
            let newEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, 126, true)!)
            self.overrideMailKeyDown(newEvent)
        case "K":
            self.overrideMailKeyDown(maskKey(withKeyCode: 126, andMask: CGEventFlags.MaskShift))
        case "o":
            msgViewer.performSelector("openMessages:", withObject: nil)
        case "r":
            msgViewer.performSelector("replyMessage:", withObject: nil)
        case "s" where hasControl == true:
            self.overrideMailKeyDown(maskKey(withKeyCode: 21, andMask: CGEventFlags.MaskCommand))
        case "s":
            msgViewer.performSelector("toggleFlag:", withObject: nil)
        case "t" where hasControl == true:
            self.overrideMailKeyDown(maskKey(withKeyCode: 19, andMask: CGEventFlags.MaskCommand))
        case "U":
            msgViewer.performSelector("markAsUnread:", withObject: nil)
        case "y":
            msgViewer.performSelector("archiveMessages:", withObject: nil)
        default:
            self.overrideMailKeyDown(event)
        }
    }
    
    dynamic func overrideMessagesKeyDown(event: NSEvent) {
        NSLog("overrideMessagesKeyDown")
        let hasCommand: Bool = event.modifierFlags.contains(.CommandKeyMask)
        let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
        switch getChar(event) {
        case "#":
            self.performSelector("deleteMessages:", withObject: nil)
        case "/":
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 3, andMask: CGEventFlags.MaskCommand))
        case "?":
            let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 3, andMask: flags))
        case "a" where hasControl == true:
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 23, andMask: CGEventFlags.MaskCommand))
        case "a":
            self.performSelector("replyAllMessage:", withObject: nil)
        case "c":
            self.performSelector("showComposeWindow:", withObject: nil)
        case "d" where hasControl == true:
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 20, andMask: CGEventFlags.MaskCommand))
        case "e":
            self.performSelector("archiveMessages:", withObject: nil)
        case "f" where hasCommand == true:
            self.overrideMessagesKeyDown(event)
        case "f":
            self.performSelector("forwardMessage:", withObject: nil)
        case "i" where hasControl == true:
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 18, andMask: CGEventFlags.MaskCommand))
        case "r":
            self.performSelector("replyMessage:", withObject: nil)
        case "s" where hasControl == true:
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 21, andMask: CGEventFlags.MaskCommand))
        case "s":
            self.performSelector("toggleFlag:", withObject: nil)
        case "t" where hasControl == true:
            self.overrideMessagesKeyDown(maskKey(withKeyCode: 19, andMask: CGEventFlags.MaskCommand))
        case "y":
            self.performSelector("archiveMessages:", withObject: nil)
        default:
            self.overrideMessagesKeyDown(event)
        }
    }
    
    private func getChar(event: NSEvent) -> String {
        let chars: String = event.charactersIgnoringModifiers!
        let charIdx: String.Index = chars.startIndex.advancedBy(1)
        let char: String = chars.substringToIndex(charIdx)
        return char
    }
    
    private func maskKey(withKeyCode code: UInt16, andMask mask: CGEventFlags) -> NSEvent! {
        let cgEventRef: CGEventRef = CGEventCreateKeyboardEvent(nil, code, true)!
        CGEventSetFlags(cgEventRef, mask)
        let nsEvent: NSEvent! = NSEvent(CGEvent: cgEventRef)
        return nsEvent
    }
}
