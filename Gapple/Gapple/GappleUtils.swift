//
//  GappleUtils.swift
//  Gapple
//
//  Created by Duncan DeVore on 12/1/15.
//  Copyright © 2015 ___ironfish___. All rights reserved.
//

import Cocoa
import Foundation

enum Kbind: String {
    case ARCHIVE     = "archiveMessages:"
    case COMPOSE     = "showComposeWindow:"
    case DELETE      = "deleteMessages:"
    case FORWARD     = "forwardMessage:"
    case JUNK        = "markAsJunkMail:"
    case KEY_DOWN    = "keyDown:"
    case OPEN        = "openMessages:"
    case READ        = "markAsRead:"
    case REPLY       = "replyMessage:"
    case REPLY_ALL   = "replyAllMessage:"
    case SWIZZLE     = "swizzleKeyDown:"
    case TOGGLE_FLAG = "toggleFlag:"
    case UNREAD      = "markAsUnread:"
}

enum Kcode: UInt16 {
    case ARROW_DOWN  = 125
    case ARROW_UP    = 126
    case F           = 3
    case ONE         = 18
    case TWO         = 19
    case THREE       = 20
    case FOUR        = 21
    case FIVE        = 23
}

class GappleUtils {
    
    static let instance = GappleUtils()
    
    func getChar(event: NSEvent) -> String {
        let chars: String = event.charactersIgnoringModifiers!
        let charIdx: String.Index = chars.startIndex.advancedBy(1)
        let char: String = chars.substringToIndex(charIdx)
        return char
    }
    
    func maskKey(withKeyCode code: UInt16, andMask mask: CGEventFlags) -> NSEvent! {
        let cgEventRef: CGEventRef = CGEventCreateKeyboardEvent(nil, code, true)!
        CGEventSetFlags(cgEventRef, mask)
        let nsEvent: NSEvent! = NSEvent(CGEvent: cgEventRef)
        return nsEvent
    }
}