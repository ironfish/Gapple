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
      let origSelector = Selector(Binding.KeyDown.rawValue)
      let swizSelector = Selector(Binding.Swizzle.rawValue)
      let origMethod = class_getInstanceMethod(cls, origSelector)
      let swizMethod = class_getInstanceMethod(self, swizSelector)
      class_addMethod(cls, swizSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
      class_replaceMethod(cls, origSelector, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod))
      NSLog("GappleMessageViewer Initialized")
    }
  }
    
  dynamic func swizKeyDown(event: NSEvent) {
    NSLog("overrideMessagesKeyDown")
    let hasCommand: Bool = event.modifierFlags.contains(.CommandKeyMask)
    let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
    switch Utils.instance.getChar(event) {
      case "#":
        self.performSelector(Selector(Binding.Delete.rawValue), withObject: nil)
      case "/":
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.F.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "?":
        let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.F.rawValue, andFlags: flags))
      case "a" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Five.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "a":
        self.performSelector(Selector(Binding.ReplyAll.rawValue), withObject: nil)
      case "c":
        self.performSelector(Selector(Binding.Compose.rawValue), withObject: nil)
      case "d" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Three.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "e":
        self.performSelector(Selector(Binding.Archive.rawValue), withObject: nil)
      case "f" where hasCommand == true:
        self.swizKeyDown(event)
      case "f":
        self.performSelector(Selector(Binding.Forward.rawValue), withObject: nil)
      case "i" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.One.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "r":
        self.performSelector(Selector(Binding.Reply.rawValue), withObject: nil)
      case "s" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Four.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "s":
        self.performSelector(Selector(Binding.ToggleFlag.rawValue), withObject: nil)
      case "t" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Two.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "y":
        self.performSelector(Selector(Binding.Archive.rawValue), withObject: nil)
      default:
        self.swizKeyDown(event)
      }
  }
}
