//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//


import ScriptingBridge
import AppKit
import Cocoa
import Foundation

class GappleMailTableView: NSObject {

  override class func initialize() {

    struct Static {
      static var token: dispatch_once_t = 0
    }

    dispatch_once(&Static.token) {
      let utils: Utils = Utils.instance
      utils.dispatchOnce(self, clazz: Clazz.MailTableView)
    }
  }

  dynamic func swizKeyDown(event:NSEvent) {
    let shorts: ShortcutService = ShortcutService.instance
    let utils: Utils = Utils.instance
    let key: String = utils.getChar(event)

    NSLog(Clazz.MailTableView.rawValue + ": " + String(event))

    switch key {
    case "?":
      shorts.shortcutsAlert(self)
    case "/":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.FKey.get(), andFlags: Masks.AltCmd.get()))
    case "j":
      // todo would much prefer to use:
      // let mailTableViewManager = self.performSelector(Selector("delegate"), withObject: nil).takeUnretainedValue()
      // mailTableViewManager.performSelector(Selector("selectNextMessageMovingDownward:"), withObject: false)
      // but cannot get the mask to work properly with performSelector
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowDn.get()))
    case "k":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowUp.get()))
    case "J":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowDn.get(), andFlags: Masks.Shift.get()))
    case "K":
      self.swizKeyDown(utils.getEvent(self, withKey: Codes.ArrowUp.get(), andFlags: Masks.Shift.get()))
    default:
      self.swizKeyDown(event)
    }
  }
}
