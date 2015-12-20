//
//  ToViewController.swift
//  Gapple
//
//  Created by Duncan DeVore on 12/19/15.
//  Copyright © 2015 ___ironfish___. All rights reserved.
//

import Cocoa

class ToViewController: NSViewController {

  @IBOutlet weak var pathsTableView: NSTableView!

  var paths = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    pathsTableView.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
  }

  override func keyDown(event:NSEvent) {
    let utils: Utils = Utils.instance
    let key: String = utils.getChar(event)
    switch key {
    case "j":
      let nr = nextRow()
      pathsTableView.selectRowIndexes(NSIndexSet(index: nr), byExtendingSelection: false)
      pathsTableView.scrollRowToVisible(nr)
    case "k":
      let pr = prevRow()
      pathsTableView.selectRowIndexes(NSIndexSet(index: pr), byExtendingSelection: false)
      pathsTableView.scrollRowToVisible(pr)
    default:
      super.keyDown(event)
    }
  }

  func prevRow() -> Int {
    var selectedRow = self.pathsTableView.selectedRow
    if selectedRow > 0 {
      selectedRow -= 1
    }
    return selectedRow
  }

  func nextRow() -> Int {
    var selectedRow = self.pathsTableView.selectedRow
    if selectedRow < (self.paths.count - 1) {
      selectedRow += 1
    }
    return selectedRow
  }

  override var acceptsFirstResponder : Bool {
    return true
  }

  func selectedPath() -> String? {
    let selectedRow = self.pathsTableView.selectedRow;
    if selectedRow >= 0 && selectedRow < self.paths.count {
      let path = paths[selectedRow]
      return path
    }
    return nil
  }

  func setupPaths(_paths: [String]) {
    paths = _paths
  }
}

// MARK: - NSTableViewDataSource
extension ToViewController: NSTableViewDataSource {
  func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
    return self.paths.count
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    if tableColumn!.identifier == "PathColumn" {
      let path = self.paths[row]
      cellView.textField!.stringValue = path
      return cellView
    }
    return cellView
  }
}

// MARK: - NSTableViewDelegate
extension ToViewController: NSTableViewDelegate {
  func tableViewSelectionDidChange(notification: NSNotification) {
//    let pathSelected = selectedPath()!
//    NSLog(pathSelected)
  }

  func toAlert(messageText:String, sender:NSObject, selector:Selector, dict: [String: MailboxEntry]) {
    let alert: NSAlert = NSAlert()
    let views: [AnyObject] = alert.window.contentView!.subviews
    let informativeTextFont: NSFont = NSFont(name: "Menlo", size: 12.0)!
    let messageTextFont: NSFont = NSFont(name: "Arial", size: 16.0)!
    (views[4] as! NSTextField).font = messageTextFont
    (views[5] as! NSTextField).font = informativeTextFont
    alert.messageText = messageText
    alert.informativeText = "Select Mailbox"
    alert.addButtonWithTitle(NSLocalizedString("OK", comment: ""))
    alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: ""))
    alert.accessoryView = self.view
    let window = NSApp.mainWindow
    alert.beginSheetModalForWindow(window!, completionHandler: { (returnCode) -> Void in
      switch (returnCode) {
      case NSAlertFirstButtonReturn:
        if self.selectedPath() != nil {
          let path = self.selectedPath()!
          NSLog("PATH_SELECTED: " + path)
          let mailboxEntry: MailboxEntry = dict[path]!
          let mailbox = mailboxEntry.mailbox
          sender.performSelector(selector, withObject: [mailbox])
        }
      case NSAlertSecondButtonReturn:
        NSLog("CANCEL")
      default:
        NSLog("DEFAULT")
      }
    })
  }
}
