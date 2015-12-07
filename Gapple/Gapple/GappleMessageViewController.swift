//
// Created by Duncan DeVore on 12/5/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

class GappleMessageViewController: NSObject {

  override class func initialize() {

    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let cls: AnyClass = NSClassFromString("MessageViewController")!
      let origSelector = Selector(Binding.KeyDown.rawValue)
      let swizSelector = Selector(Binding.Swizzle.rawValue)
      let origMethod = class_getInstanceMethod(cls, origSelector)
      let swizMethod = class_getInstanceMethod(self, swizSelector)
      class_addMethod(cls, swizSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
      class_replaceMethod(cls, origSelector, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod))
      NSLog("GappleMessageViewController Initialized")
    }
  }

  dynamic func swizKeyDown(event: NSEvent) {
    let shorts: Shortcuts = Shortcuts.instance
    let key: String = shorts.getChar(event)

    NSLog("MESSAGE-VIEW-CONTROLLER: " + String(event))

    switch key {
    case "j":
      self.eventDate = nil
      self.swizKeyDown(shorts.getEvent(withKey: 124))
    case "k":
      self.eventDate = nil
      self.swizKeyDown(shorts.getEvent(withKey: 123))
    default:
      self.swizKeyDown(event)
    }
  }
}
