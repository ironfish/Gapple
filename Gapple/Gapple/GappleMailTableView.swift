//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

class GappleMailTableView: NSObject {

//    override init() {
//        self.name = "?"
//    }
//
//    init(name: String) {
//        self.name = name
//    }
//
//  @objc dynamic var name: String
//
//  dynamic func namer(name: String) {
//    self.name = name
//  }
      
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
    let hasControl: Bool = event.modifierFlags.contains(.ControlKeyMask)
    let msgViewer = self.performSelector(Selector("delegate")).takeUnretainedValue()
        .performSelector(Selector("delegate")).takeUnretainedValue()
    switch Utils.instance.getChar(event) {
      case "#":
        msgViewer.performSelector(Selector(Binding.Delete.rawValue), withObject: nil)
      case "/" where hasControl == true:
        let flags = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.F.rawValue, andFlags: flags))
      case "/":
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.F.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "?":
//        name = "duncan"
//        NSLog(name as! String)
//        self.name = "Duncan"
        let alert: NSAlert = NSAlert()
        let views: [AnyObject] = alert.window.contentView!.subviews
        let informativeTextFont: NSFont = NSFont(name: "Menlo", size: 12.0)!
        let messageTextFont: NSFont = NSFont(name: "Arial", size: 16.0)!
        (views[4] as! NSTextField).font = messageTextFont
        (views[5] as! NSTextField).font = informativeTextFont
        alert.messageText = "Keyboard Shortcuts"
        alert.informativeText = Utils.instance.getShortCuts()
        alert.runModal()
      case "!":
        msgViewer.performSelector(Selector(Binding.Junk.rawValue), withObject: nil)
      case "a" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Five.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "a":
        msgViewer.performSelector(Selector(Binding.ReplyAll.rawValue), withObject: nil)
      case "c":
        msgViewer.performSelector(Selector(Binding.Compose.rawValue), withObject: nil)
      case "d" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Three.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "e":
        msgViewer.performSelector(Selector(Binding.Archive.rawValue), withObject: nil)
      case "f":
        msgViewer.performSelector(Selector(Binding.Forward.rawValue), withObject: nil)
      case "i" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.One.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "I":
        msgViewer.performSelector(Selector(Binding.Read.rawValue), withObject: nil)
      case "j":
        let nsEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, Code.ArrowDown.rawValue, true)!)
        self.swizKeyDown(nsEvent)
      case "J":
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.ArrowDown.rawValue, andFlags: CGEventFlags.MaskShift))
      case "k":
        let newEvent: NSEvent! = NSEvent(CGEvent: CGEventCreateKeyboardEvent(nil, Code.ArrowUp.rawValue, true)!)
        self.swizKeyDown(newEvent)
      case "K":
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.ArrowUp.rawValue, andFlags: CGEventFlags.MaskShift))
      case "l":
        let mainMenu: NSMenu = NSApplication.sharedApplication().mainMenu!
        let messagesMenu: NSMenuItem = (mainMenu.itemWithTitle("Message"))!
        let moveToMenu: NSMenuItem = (messagesMenu.submenu?.itemWithTitle("Move to"))!
        if moveToMenu.hasSubmenu {
          let subMenu: NSMenu = moveToMenu.submenu!
          subMenu.delegate!.menuNeedsUpdate!(subMenu)
          if subMenu.respondsToSelector(Selector("_sendMenuOpeningNotification:")) {
            subMenu.performSelector(Selector("_sendMenuOpeningNotification:"))
          }
          var items: [NSMenuItem] = moveToMenu.submenu!.itemArray
          for var i = 0; i < items.count; i++ {
            let menuItem: NSMenuItem = items[i]
            NSLog(menuItem.title)
          }
        }
      case "o":
        msgViewer.performSelector(Selector(Binding.Open.rawValue), withObject: nil)
      case "r":
        msgViewer.performSelector(Selector(Binding.Reply.rawValue), withObject: nil)
      case "s" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Four.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "s":
        msgViewer.performSelector(Selector(Binding.ToggleFlag.rawValue), withObject: nil)
      case "t" where hasControl == true:
        self.swizKeyDown(Utils.instance.getEvent(withKey: Code.Two.rawValue, andFlags: CGEventFlags.MaskCommand))
      case "U":
        msgViewer.performSelector(Selector(Binding.Unread.rawValue), withObject: nil)
      case "y":
        msgViewer.performSelector(Selector(Binding.Archive.rawValue), withObject: nil)
      default:
        self.swizKeyDown(event)
    }
  }
}
