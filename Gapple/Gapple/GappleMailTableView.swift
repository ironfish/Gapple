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
      let origSelector: Selector = Selector(Binding.KeyDown.rawValue)
      let swizSelector: Selector = Selector(Binding.Swizzle.rawValue)
      let origMethod: Method = class_getInstanceMethod(cls, origSelector)
      let swizMethod: Method = class_getInstanceMethod(self, swizSelector)
      class_addMethod(cls, swizSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
      class_replaceMethod(cls, origSelector, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod))
      NSLog("GappleMailTableView Initialized")
    }
  }

  dynamic func swizKeyDown(event: NSEvent) {
    let shorts: Shortcuts = Shortcuts.instance
    let key: String = shorts.getChar(event)
    let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)

    NSLog("MAIL-TABLE-VIEW: " + String(event))

    switch key {
    case "?":
      self.eventDate = nil
      let alert = shorts.getAlert("?")
      alert.beginSheetModalForWindow(NSApplication.sharedApplication().mainWindow!) { responseCode in
        if NSAlertFirstButtonReturn == responseCode {
          NSLog("FirstButton")
        }
      }
    case "/" where hasControl:
      let short = shorts.getShortcut("^" + key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!, andFlags: short!.flags!))
    case "j",
         "k":
      let short = shorts.getShortcut(key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!))
    case "J",
         "K":
      let short = shorts.getShortcut(key)
      self.swizKeyDown(shorts.getEvent(withKey: short!.code!, andFlags: short!.flags!))
    default:
      self.swizKeyDown(event)
    }
  }
}
