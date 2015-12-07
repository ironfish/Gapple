//
// Created by Duncan DeVore on 12/4/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

enum Binding: String {
  case Archive    = "archiveMessages:"
  case Compose    = "showComposeWindow:"
  case Delete     = "deleteMessages:"
  case Forward    = "forwardMessage:"
  case Junk       = "markAsJunkMail:"
  case KeyDown    = "keyDown:"
  case Move       = "moveMessage:"
  case Open       = "openMessages:"
  case Read       = "markAsRead:"
  case Reply      = "replyMessage:"
  case ReplyAll   = "replyAllMessage:"
  case Swizzle    = "swizKeyDown:"
  case ToggleFlag = "toggleFlag:"
  case Unread     = "markAsUnread:"
}

enum Code: UInt16 {
  case ArrowDown  = 125
  case ArrowLeft  = 123
  case ArrowRight = 124
  case ArrowUp    = 126
  case F          = 3
  case W          = 0x0D
  case One        = 18
  case Two        = 19
  case Three      = 20
  case Four       = 21
  case Five       = 23
}

struct Shortcut {
    let name: String
    let desc: String
    let selector: String?
    let code: UInt16?
    let flags: CGEventFlags?
    let alert: Bool
  
    init(
        name: String,
        withDesc desc: String,
        withSelector selector: String? = nil,
        withCode code: UInt16? = nil,
        withFlags flags: CGEventFlags? = nil,
        hasAlert alert: Bool = false) {
          self.name = name
          self.desc = desc
          self.selector = selector
          self.code = code
          self.flags = flags
          self.alert = alert
    }
}

class Shortcuts {

  static let instance = Shortcuts.init()

  let alternateAndCommand: CGEventFlags
  let ShortcutDict: Dictionary<String, Shortcut>

  init() {
    self.alternateAndCommand = CGEventFlags(rawValue: CGEventFlags.MaskAlternate.rawValue | CGEventFlags.MaskCommand.rawValue)!
    let command = CGEventFlags.MaskCommand
    let shift = CGEventFlags.MaskShift
    ShortcutDict = [
        "!":  Shortcut(name: "          !: ", withDesc: "Mark as junk", withSelector: Binding.Junk.rawValue),
        "#":  Shortcut(name: "          #: ", withDesc: "Delete message", withSelector: Binding.Delete.rawValue),
        "?":  Shortcut(name: "          ?: ", withDesc: "Keyboard shortcuts", hasAlert: true),
        "/":  Shortcut(name: "          /: ", withDesc: "Find in message", withCode: Code.F.rawValue, withFlags: command),
        "^/": Shortcut(name: "         ^/: ", withDesc: "Find in mailbox", withCode: Code.F.rawValue, withFlags: alternateAndCommand),
        "a":  Shortcut(name: "          a: ", withDesc: "Go to Archive", withSelector: Binding.ReplyAll.rawValue),
        "c":  Shortcut(name: "          c: ", withDesc: "Compose message", withSelector: Binding.Compose.rawValue),
        "e":  Shortcut(name: "          e: ", withDesc: "Archive message", withSelector: Binding.Archive.rawValue),
        "f":  Shortcut(name: "          f: ", withDesc: "Forward message", withSelector: Binding.Forward.rawValue),
        "ga": Shortcut(name: "   g then a: ", withDesc: "Go to Archive", withCode: Code.Five.rawValue, withFlags: command),
        "gd": Shortcut(name: "   g then d: ", withDesc: "Go to Drafts", withCode: Code.Three.rawValue, withFlags: command),
        "gi": Shortcut(name: "   g then i: ", withDesc: "Go to Inbox", withCode: Code.One.rawValue, withFlags: command),
        "gs": Shortcut(name: "   g then s: ", withDesc: "Go to Flagged", withCode: Code.Four.rawValue, withFlags: command),
        "gt": Shortcut(name: "   g then t: ", withDesc: "Go to Sent", withCode: Code.Two.rawValue, withFlags: command),
        "I":  Shortcut(name: "<shift> + i: ", withDesc: "Mark as read", withSelector: Binding.Read.rawValue),
        "j":  Shortcut(name: "          j: ", withDesc: "Next message", withCode: Code.ArrowDown.rawValue),
        "J":  Shortcut(name: "<shift> + j: ", withDesc: "Next message select", withCode: Code.ArrowDown.rawValue, withFlags: shift),
        "k":  Shortcut(name: "          k: ", withDesc: "Previous message", withCode: Code.ArrowUp.rawValue),
        "K":  Shortcut(name: "<shift> + k: ", withDesc: "Previous message select", withCode: Code.ArrowUp.rawValue, withFlags: shift),
        "l":  Shortcut(name: "          l: ", withDesc: "Move message", withSelector: Binding.Move.rawValue, hasAlert: true),
        "o":  Shortcut(name: "          o: ", withDesc: "Open message", withSelector: Binding.Open.rawValue),
        "r":  Shortcut(name: "          r: ", withDesc: "Reply", withSelector: Binding.Reply.rawValue),
        "s":  Shortcut(name: "          s: ", withDesc: "Toggle flag", withSelector: Binding.ToggleFlag.rawValue),
        "u":  Shortcut(name: "          u: ", withDesc: "Back to threadlist", withCode: Code.W.rawValue, withFlags: command),
        "U":  Shortcut(name: "<shift> + u: ", withDesc: "Mark as unread", withSelector: Binding.Unread.rawValue),
        "v":  Shortcut(name: "          v: ", withDesc: "Move message", withSelector: Binding.Move.rawValue, hasAlert: true),
        "y":  Shortcut(name: "          y: ", withDesc: "Archive message", withSelector: Binding.Archive.rawValue)
    ]
  }

  func getShortcuts() -> String {
    var shorts: String = "------------ Navigation ------------\n"
    shorts = shorts + getShortcut("ga")!.name + getShortcut("ga")!.desc + "\n"
    shorts = shorts + getShortcut("gd")!.name + getShortcut("gd")!.desc + "\n"
    shorts = shorts + getShortcut("gi")!.name + getShortcut("gi")!.desc + "\n"
    shorts = shorts + getShortcut("gs")!.name + getShortcut("gs")!.desc + "\n"
    shorts = shorts + getShortcut("gt")!.name + getShortcut("gt")!.desc + "\n"
    shorts = shorts + getShortcut("j")!.name + getShortcut("j")!.desc + "\n"
    shorts = shorts + getShortcut("J")!.name + getShortcut("J")!.desc + "\n"
    shorts = shorts + getShortcut("k")!.name + getShortcut("k")!.desc + "\n"
    shorts = shorts + getShortcut("K")!.name + getShortcut("K")!.desc + "\n"
    shorts = shorts + getShortcut("u")!.name + getShortcut("u")!.desc + "\n"
    shorts = shorts + "\n------------ Search ----------------\n"
    shorts = shorts + getShortcut("/")!.name + getShortcut("/")!.desc + "\n"
    shorts = shorts + getShortcut("^/")!.name + getShortcut("^/")!.desc + "\n"
    shorts = shorts + "\n------------ Actions ---------------\n"
    shorts = shorts + getShortcut("!")!.name + getShortcut("!")!.desc + "\n"
    shorts = shorts + getShortcut("#")!.name + getShortcut("#")!.desc + "\n"
    shorts = shorts + getShortcut("?")!.name + getShortcut("?")!.desc + "\n"
    shorts = shorts + getShortcut("c")!.name + getShortcut("c")!.desc + "\n"
    shorts = shorts + getShortcut("e")!.name + getShortcut("e")!.desc + "\n"
    shorts = shorts + getShortcut("y")!.name + getShortcut("y")!.desc + "\n"
    shorts = shorts + getShortcut("f")!.name + getShortcut("f")!.desc + "\n"
    shorts = shorts + getShortcut("o")!.name + getShortcut("o")!.desc + "\n"
    shorts = shorts + getShortcut("r")!.name + getShortcut("r")!.desc + "\n"
    shorts = shorts + getShortcut("a")!.name + getShortcut("a")!.desc + "\n"
    shorts = shorts + getShortcut("I")!.name + getShortcut("I")!.desc + "\n"
    shorts = shorts + getShortcut("s")!.name + getShortcut("s")!.desc + "\n"
    shorts = shorts + getShortcut("U")!.name + getShortcut("U")!.desc + "\n"
    shorts = shorts + getShortcut("l")!.name + getShortcut("l")!.desc + "\n"
    shorts = shorts + getShortcut("v")!.name + getShortcut("v")!.desc + "\n"
    shorts = shorts + "\n"
    shorts = shorts + "NOTE: u works only for open messages\n"
    shorts = shorts + "NOTE: ^ = Control Key"
    return shorts
  }

  func getAlert(key: String) -> NSAlert {
    switch key {
    case "?":
      return shortcutsAlert()
//    case "g then l":
//      return shortcutsAlert()
    default:
      return shortcutsAlert()
    }
  }
    
  func shortcutsAlert() -> NSAlert {
    let alert: NSAlert = NSAlert()
    let views: [AnyObject] = alert.window.contentView!.subviews
    let informativeTextFont: NSFont = NSFont(name: "Menlo", size: 12.0)!
    let messageTextFont: NSFont = NSFont(name: "Arial", size: 16.0)!
    (views[4] as! NSTextField).font = messageTextFont
    (views[5] as! NSTextField).font = informativeTextFont
    alert.messageText = "Keyboard Shortcuts"
    alert.informativeText = getShortcuts()
//    alert.informativeText = Utils.instance.getShortCuts()
    alert.addButtonWithTitle(NSLocalizedString("Close", comment:""))
    return alert
  }
    
  func getEvent(withKey key: UInt16, andFlags flags: CGEventFlags? = nil) -> NSEvent! {
    let cgEventRef: CGEventRef = CGEventCreateKeyboardEvent(nil, key, true)!
    if flags != nil {
      CGEventSetFlags(cgEventRef, flags!)      
    }
    let nsEvent: NSEvent! = NSEvent(CGEvent: cgEventRef)
    return nsEvent
  }

  func getShortcut(key: String) -> Shortcut? {
    return self.ShortcutDict[key]
  }

  func intervalValid(date: NSDate?) -> Bool {
    if date == nil { return false }
    let timePassed = (date?.timeIntervalSinceNow)! * -1000.0
    return (timePassed < 500) ? true : false
  }

  func getChar(event: NSEvent) -> String {
    let chars: String = event.charactersIgnoringModifiers!
    let charIdx: String.Index = chars.startIndex.advancedBy(1)
    let char: String = chars.substringToIndex(charIdx)
    return char
  }
}
