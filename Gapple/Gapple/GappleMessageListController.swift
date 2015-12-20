//
// Created by Duncan DeVore on 12/13/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

class GappleMessageListController: NSObject {

  override class func initialize() {

    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let utils: Utils = Utils.instance
      utils.dispatchOnce(self, clazz: Clazz.MessageListController)
    }
  }

  dynamic func swizKeyDown(event: NSEvent) {
    let utils: Utils = Utils.instance
    let key: String = utils.getChar(event)

    NSLog(Clazz.MessageListController.rawValue + ": " + String(event))

    switch key {
    case "u":  // so we don't close the main window
      self.eventDate = nil
//      shorts.action(self, selector: Selectors.Unread)
    default:
      self.swizKeyDown(event)
    }
  }
}
