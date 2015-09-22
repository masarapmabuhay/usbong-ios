//
//  UsbongTree.swift
//  usbong
//
//  Created by Joe Amanse on 22/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class UsbongTree {
    var treeDirectoryURL: NSURL
    var name: String {
        // Tree directory URL ends with name.utree/
        return treeDirectoryURL.lastPathComponent?.componentsSeparatedByString(".").first ?? UsbongFileManager.defaultManager().defaultFileName
    }
    var parser: UsbongXMLParser?
    
    // Task Nodes
    var taskNodes: [TaskNode] = []
    var currentTaskNode: TaskNode?
    var previousTaskNode: TaskNode?
    var nextTaskNode: TaskNode?
    
    init(treeDirectoryURL: NSURL) {
        self.treeDirectoryURL = treeDirectoryURL
        // Find XML
        let XMLURL = treeDirectoryURL.URLByAppendingPathComponent("\(name).xml")
        print(XMLURL.path)
        
        parser = UsbongXMLParser(contentsOfURL: XMLURL)
    }
    
    func transitionToNextTaskNode() {
    }
    func transitionToPreviousTaskNode() {
    }
}