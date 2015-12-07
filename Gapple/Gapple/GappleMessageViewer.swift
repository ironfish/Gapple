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
    let shorts: Shortcuts = Shortcuts.instance
    let key: String = shorts.getChar(event)
    let hasAlternate: Bool = event.modifierFlags.contains(.AlternateKeyMask)
    let hasCommand: Bool = event.modifierFlags.contains(.CommandKeyMask)
    let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
    let isInterval: Bool = shorts.intervalValid(self.eventDate)

    NSLog("MESSAGE-VIEW: " + String(event))

    switch key {
    case "f" where hasAlternate && hasCommand == true:
      self.swizKeyDown(event)
    case "a" where isInterval == true,
         "d" where isInterval == true,
         "i" where isInterval == true,
         "s" where isInterval == true,
         "t" where isInterval == true:
      self.eventDate = nil
      let short = shorts.getShortcut("g" + key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!, andFlags: short!.flags!))
    case "g":
      self.eventDate = NSDate()
      self.swizKeyDown(event)
    case "#",
         "!",
         "a",
         "c",
         "e",
         "f",
         "I",
         "o",
         "r",
         "s",
         "U",
         "y":
      self.eventDate = nil
      let short = shorts.getShortcut(key)
      self.performSelector(Selector(short!.selector!), withObject: nil)
    case "/" where hasControl:
      self.eventDate = nil
      let short = shorts.getShortcut("^" + key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!, andFlags: short!.flags!))
    case "/", "u":
      self.eventDate = nil
      let short = shorts.getShortcut(key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!, andFlags: short!.flags!))
    default:
      swizKeyDown(event)
    }
  }
}
