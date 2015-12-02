//
//  Utils.swift
//  Gapple
//
//  Created by Duncan DeVore on 12/1/15.
//  Copyright © 2015 ___ironfish___. All rights reserved.
//

import Cocoa
import Foundation

enum Binding: String {
  case Archive    = "archiveMessages:"
  case Compose    = "showComposeWindow:"
  case Delete     = "deleteMessages:"
  case Forward    = "forwardMessage:"
  case Junk       = "markAsJunkMail:"
  case KeyDown    = "keyDown:"
  case Open       = "openMessages:"
  case Read       = "markAsRead:"
  case Reply      = "replyMessage:"
  case ReplyAll   = "replyAllMessage:"
  case Swizzle    = "swizKeyDown:"
  case ToggleFlag = "toggleFlag:"
  case Unread     = "markAsUnread:"
}

enum Code: UInt16 {
  case ArrowDown = 125
  case ArrowUp   = 126
  case F         = 3
  case One       = 18
  case Two       = 19
  case Three     = 20
  case Four      = 21
  case Five      = 23
}

enum Shortcuts: String {
  case Navigation           = "----- Navigation ---------------\n"
  case CtrlLowerCaseA       = "  ^a: Go to Archive\n"
  case CtrlLowerCaseD       = "  ^d: Go to Drafts\n"
  case CtrlLowerCaseI       = "  ^i: Go to Inbox\n"
  case CtrlLowerCaseS       = "  ^s: Go to Flagged\n"
  case CtrlLowerCaseT       = "  ^t: Go to Sent\n"
  case LowerCaseJ           = "   j: Next message\n"
  case UpperCaseJ           = "   J: Next message select\n"
  case LowerCaseK           = "   k: Previous message\n"
  case UpperCaseK           = "   K: Previous message select\n"
  case Search               = "\n----- Search -------------------\n"
  case ForwardSlash         = "   /: Find in message\n"
  case CtrlForwardSlash     = "  ^/: Find in mailbox\n"
  case Actions              = "\n----- Actions ------------------\n"
  case ExclamationMark      = "   !: Mark as junk\n"
  case PoundSign            = "   #: Delete message\n"
  case QuestionMark         = "   ?: Keyboard shortcuts\n"
  case LowerCaseC           = "   c: Compose message\n"
  case LowerCaseEY          = "e, y: Archive message\n"
  case LowerCaseF           = "   f: Forward message\n"
  case LowerCaseO           = "   o: Open message\n"
  case LowerCaseR           = "   r: Reply\n"
  case LowerCaseA           = "   a: Reply to all\n"
  case UpperCaseI           = "   I: Mark as read\n"
  case UpperCaseU           = "   U: Mark as unread\n"
  case LowerCaseS           = "   s: Toggle flag\n"
  case Note                 = "\nNOTE: ^ = Control Key"
}

class Utils {

  static let instance = Utils()

  func getChar(event: NSEvent) -> String {
    let chars: String = event.charactersIgnoringModifiers!
    let charIdx: String.Index = chars.startIndex.advancedBy(1)
    let char: String = chars.substringToIndex(charIdx)
    return char
  }
    
  func getEvent(withKey key: UInt16, andFlags flags: CGEventFlags) -> NSEvent! {
    let cgEventRef: CGEventRef = CGEventCreateKeyboardEvent(nil, key, true)!
    CGEventSetFlags(cgEventRef, flags)
    let nsEvent: NSEvent! = NSEvent(CGEvent: cgEventRef)
    return nsEvent
  }

  func getShortCuts() -> String {
    return Shortcuts.Navigation.rawValue +
        Shortcuts.CtrlLowerCaseA.rawValue +
        Shortcuts.CtrlLowerCaseD.rawValue +
        Shortcuts.CtrlLowerCaseI.rawValue +
        Shortcuts.CtrlLowerCaseS.rawValue +
        Shortcuts.CtrlLowerCaseT.rawValue +
        Shortcuts.LowerCaseJ.rawValue +
        Shortcuts.UpperCaseJ.rawValue +
        Shortcuts.LowerCaseK.rawValue +
        Shortcuts.UpperCaseK.rawValue +
        Shortcuts.Search.rawValue +
        Shortcuts.ForwardSlash.rawValue +
        Shortcuts.CtrlForwardSlash.rawValue +
        Shortcuts.Actions.rawValue +
        Shortcuts.ExclamationMark.rawValue +
        Shortcuts.PoundSign.rawValue +
        Shortcuts.QuestionMark.rawValue +
        Shortcuts.LowerCaseC.rawValue +
        Shortcuts.LowerCaseEY.rawValue +
        Shortcuts.LowerCaseF.rawValue +
        Shortcuts.LowerCaseO.rawValue +
        Shortcuts.LowerCaseR.rawValue +
        Shortcuts.LowerCaseA.rawValue +
        Shortcuts.UpperCaseI.rawValue +
        Shortcuts.UpperCaseU.rawValue +
        Shortcuts.LowerCaseS.rawValue +
        Shortcuts.Note.rawValue
  }
}
