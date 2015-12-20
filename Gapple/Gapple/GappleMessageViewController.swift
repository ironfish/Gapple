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
      let utils: Utils = Utils.instance
      utils.dispatchOnce(self, clazz: Clazz.MessageViewController)
    }
  }

  dynamic func swizKeyDown(event:NSEvent) {
    let utils: Utils = Utils.instance
    let key: String = utils.getChar(event)

    NSLog(Clazz.MessageViewController.rawValue + ": " + String(event))

    switch key {
    case "n":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowRt.get()))
    case "p":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowLf.get()))
    default:
      self.swizKeyDown(event)
    }
  }
}
