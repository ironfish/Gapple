//
// Created by Duncan DeVore on 12/7/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation

struct MailboxEntry {
  let accountName: String
  let name: String
  let mailbox: AnyObject
}
enum ToAction {
  case Copy, Go, Move
}

enum Mailboxes:String {
  case Archive, Drafts, Flagged, Inbox, Junk, Sent, Trash
}

class MailboxService {

  static let instance = MailboxService.init()

  init() {}

  let utils: Utils = Utils.instance

  func selectSpecialMailbox(sender: NSObject, zelector: Zelector) -> Void {
    sender.eventDate = nil;
    if sender.className != Clazz.SingleMessageViewer.rawValue {
      sender.performSelector(Zelector.setSelectedMailboxes.get(), withObject: [specialMailbox(sender, zelector: zelector)])
    }
  }

  func toMailbox(sender:NSObject, toAction: ToAction) {
    sender.eventDate = nil;
    if sender.className != Clazz.SingleMessageViewer.rawValue {
      var mailboxDict = [String: MailboxEntry]()
      var messageText: String
      var selector: Selector
      switch toAction {
      case .Copy:
        mailboxDict = copyMailboxesDict(sender)
        messageText = "Copy to"
        selector = Zelector.setSelectedMailboxes.get()
      case .Go:
        mailboxDict = goMailboxesDict(sender)
        messageText = "Go to"
        selector = Zelector.setSelectedMailboxes.get()
      case .Move:
        mailboxDict = moveMailboxesDict(sender)
        messageText = "Move to"
        selector = Zelector.setSelectedMailboxes.get()
      }

      var keys = [String]()
      let sortedKeys = Array(mailboxDict.keys).sort(<)
      for key in sortedKeys {
        keys.append(String(key))
      }

      var tvc: ToViewController!
      let gappleBundle = NSBundle(identifier: "ironfish.Gapple")
      tvc = ToViewController(nibName: "ToViewController", bundle: gappleBundle)
      tvc.setupPaths(keys)
      tvc.toAlert(messageText, sender: sender, selector: selector, dict: mailboxDict)
    }
  }

  func savingHandler(response: NSModalResponse) {
    switch(response) {
    case NSAlertFirstButtonReturn:
      NSLog("Save")
    case NSAlertSecondButtonReturn:
      NSLog("Cancel")
    case NSAlertThirdButtonReturn:
      NSLog("Don't Save")
    default:
      break
    }
  }

  private func copyMailboxesDict(sender:NSObject) -> [String:MailboxEntry]{
    let mailboxes = accountMailboxesDict(ToAction.Copy)
    return mailboxes
  }

  func goMailboxesDict(sender:NSObject) -> [String:MailboxEntry]{
    var dict = [String:MailboxEntry]()

    let inbox = specialMailbox(sender, zelector: Zelector.inbox)
    dict["1/Inbox"] = MailboxEntry(accountName: "nil", name: "Inbox", mailbox: inbox)

    let draftsMailbox = specialMailbox(sender, zelector: Zelector.draftsMailbox)
    dict["2/Drafts"] = MailboxEntry(accountName: "nil", name: "Drafts", mailbox: draftsMailbox)

    let sentMailbox = specialMailbox(sender, zelector: Zelector.sentMailbox)
    dict["3/Sent"] = MailboxEntry(accountName: "nil", name: "Sent", mailbox: sentMailbox)

    let junkMailbox = specialMailbox(sender, zelector: Zelector.junkMailbox)
    dict["4/Junk"] = MailboxEntry(accountName: "nil", name: "Junk", mailbox: junkMailbox)

    let trashMailbox = specialMailbox(sender, zelector: Zelector.trashMailbox)
    dict["5/Trash"] = MailboxEntry(accountName: "nil", name: "Trash", mailbox: trashMailbox)

    let archiveMailbox = specialMailbox(sender, zelector: Zelector.Archive)
    dict["6/Archive"] = MailboxEntry(accountName: "nil", name: "Archive", mailbox: archiveMailbox)

    let acctDict = accountMailboxesDict(ToAction.Go)
    let acctKeys = Array(acctDict.keys)
    for acctKey in acctKeys {
      dict[acctKey] = acctDict[acctKey]
    }

    let smartDict = smartMailboxesDict()
    let smartKeys = Array(smartDict.keys)
    for smartKey in smartKeys {
      dict[smartKey] = smartDict[smartKey]
    }

    return dict
  }

  private func archiveMailbox(sender:AnyObject) -> AnyObject {
    let dict:[String:AnyObject] = favoritesBarMailboxes(sender)
    return dict[String(Zelector.Archive)]!
  }

  private func flaggedMailbox(sender:AnyObject) -> AnyObject {
    let dict:[String:AnyObject] = favoritesBarMailboxes(sender)
    return dict[String(Zelector.Flagged)]!
  }

  private func moveMailboxesDict(sender:NSObject) -> [String:MailboxEntry]{
    let mailboxes = accountMailboxesDict(ToAction.Move)
    return mailboxes
  }

  private func specialMailbox(sender:NSObject, zelector: Zelector) -> AnyObject {
    var mailbox: AnyObject
    switch zelector {
    case .Archive:
      mailbox = archiveMailbox(sender)
    case .Flagged:
      mailbox = flaggedMailbox(sender)
    default:
      mailbox = utils.getUnretainedObject(sender, selector: zelector.get())
    }
    return mailbox
  }

  private func smartMailboxesDict() -> [String:MailboxEntry] {
    var dict = [String:MailboxEntry]()
    let mailboxController: AnyObject = utils.getUnretainedObject(NSApplication.sharedApplication(), selector: Zelector.mailboxesController.get())
    let smartMailboxes = utils.getUnretainedObjectAsArray(mailboxController, selector: Zelector.smartMailboxes.get())

    func _toMailboxDict(mailboxes:[AnyObject], parentPath: String) -> Void {
      for mailbox in mailboxes {
        let name:String = utils.getUnretainedObjectAsString(mailbox, selector: Zelector.mailboxName.get())
        let path = "smart/" + parentPath + name
        dict[path] = MailboxEntry(accountName: "nil", name: name, mailbox: mailbox)
        let children = utils.getUnretainedObjectAsArray(mailbox, selector: Zelector.children.get())
        for child in children {
          let parentPath = name + "/"
          _toMailboxDict([child], parentPath: parentPath)
        }
      }
    }
    _toMailboxDict(smartMailboxes, parentPath: "")
    return dict
  }

  private func favoritesBarMailboxes(sender:AnyObject) -> [String:AnyObject] {
    var dict = [String:AnyObject]()
    let favoritesBarView:AnyObject = utils.getUnretainedObject(sender, selector: Zelector.favoritesBarView.get())
    let primaryMailboxes = utils.getUnretainedObjectAsArray(favoritesBarView, selector: Zelector._primaryMailboxes.get())
    for mailbox in primaryMailboxes {
      let name:String = utils.getUnretainedObjectAsString(mailbox, selector: Zelector.mailboxName.get())
      dict[name] = mailbox
    }
    return dict
  }

  private func accountMailboxesDict(toAction: ToAction) -> [String:MailboxEntry]{
    var accountMailboxes = [String:MailboxEntry]()
    let accounts = utils.getUnretainedObjectAsArray(NSApplication.sharedApplication(), selector: Zelector.accounts.get())
    for account in accounts {
      let accountName = utils.getUnretainedObjectAsString(account, selector: Zelector.displayName.get())
      let mailboxes = utils.getUnretainedObjectAsArray(account, selector: Zelector.mailboxes.get())
      for mailbox in mailboxes {
        let mailboxName = utils.getUnretainedObjectAsString(mailbox, selector: Zelector.mailboxName.get())
        let accountRelativePath = utils.getUnretainedObjectAsString(mailbox, selector: Zelector.accountRelativePath.get())
        let path = accountName + "/" + accountRelativePath
        switch toAction {
          case .Copy where validCopyToMailbox(mailboxName):
            accountMailboxes[path] = MailboxEntry(accountName: accountName, name: mailboxName, mailbox: mailbox)
          case .Copy:
            break // do nothing
          case .Go:
            accountMailboxes[path] = MailboxEntry(accountName: accountName, name: mailboxName, mailbox: mailbox)
          case .Move where validMoveToMailbox(mailboxName):
            accountMailboxes[path] = MailboxEntry(accountName: accountName, name: mailboxName, mailbox: mailbox)
          case .Move:
            break // do nothing
        }
      }
    }
    return accountMailboxes
  }

  private func validMoveToMailbox(name: String) -> Bool {
    let names = ["All Mail", "Archive", "Drafts", "Sent Mail", "Sent Messages"]
    return names.contains(name) ? false : true
  }

  private func validCopyToMailbox(name: String) -> Bool {
    let names = ["All Mail", "Archive", "Deleted Messages", "Drafts", "Inbox", "INBOX", "Junk", "Sent Mail",
                 "Sent Messages", "Spam", "Trash"]
    return names.contains(name) ? false : true
  }
}
