//
// Created by Duncan DeVore on 12/5/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

extension NSObject {
  private struct AssociatedKeys {
    static var EventDate = "nsh_EventDate"
  }
  var eventDate: NSDate? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.EventDate) as? NSDate
    }

    set {
      if let newValue = newValue {
        objc_setAssociatedObject(
        self,
            &AssociatedKeys.EventDate,
            newValue as NSDate?,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
      }
    }
  }
}

class GappleMessageListController: NSObject {

  override class func initialize() {

    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let cls: AnyClass = NSClassFromString("MessageListController")!
      let origSelector = Selector(Binding.KeyDown.rawValue)
      let swizSelector = Selector(Binding.Swizzle.rawValue)
      let origMethod = class_getInstanceMethod(cls, origSelector)
      let swizMethod = class_getInstanceMethod(self, swizSelector)
      class_addMethod(cls, swizSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
      class_replaceMethod(cls, origSelector, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod))
      NSLog("GappleMessageListController Initialized")
    }
  }

  dynamic func swizKeyDown(event: NSEvent) {
    let shorts: Shortcuts = Shortcuts.instance
    let key: String = shorts.getChar(event)
    let isInterval: Bool = shorts.intervalValid(self.eventDate)

    NSLog("MESSAGE-LIST-CONTROLLER: " + String(event))

    switch key {
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
    case "u":  // so we don't close the main window
      self.eventDate = NSDate()
    default:
      self.swizKeyDown(event)
    }
  }
}
