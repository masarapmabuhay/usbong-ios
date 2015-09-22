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
        // Get XML URL - Assume xml is located on (name).utree/(name).xml
        // And put it in UsbongXMLParser
        parser = UsbongXMLParser(contentsOfURL: treeDirectoryURL.URLByAppendingPathComponent("\(name).xml"))
    }
    
    func transitionToNextTaskNode() {
    }
    func transitionToPreviousTaskNode() {
    }
}