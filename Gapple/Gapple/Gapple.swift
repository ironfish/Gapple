//
// Created by Duncan DeVore on 11/28/15.
// Copyright (c) 2015 ___ironfish___. All rights reserved.
//

import AppKit
import Cocoa
import Foundation


class Gapple: NSObject {
    
    override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            GappleMailTableView.initialize()
            GappleMessageViewer.initialize()
            NSLog("Gapple Initialized")
        }
    }
}
