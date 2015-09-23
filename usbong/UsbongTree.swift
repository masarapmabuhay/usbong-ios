//
//  UsbongTree.swift
//  usbong
//
//  Created by Joe Amanse on 22/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation
import SWXMLHash

class UsbongTree {
    var treeDirectoryURL: NSURL
    var name: String {
        // Tree directory URL ends with name.utree/
        if let folderNameWithoutExtension = treeDirectoryURL.lastPathComponent?.componentsSeparatedByString(".").first {
            if folderNameWithoutExtension.stringByReplacingOccurrencesOfString(" ", withString: "").characters.count > 0 {
                return folderNameWithoutExtension
            }
        }
        return UsbongFileManager.defaultManager().defaultFileName
    }
    var parser: UsbongXMLParser
    
    // Task Nodes
    var taskNodes: [TaskNode] = []
    var currentTaskNode: TaskNode?
    var previousTaskNode: TaskNode?
    var nextTaskNode: TaskNode?
    
    init(treeDirectoryURL: NSURL) {
        self.treeDirectoryURL = treeDirectoryURL
        
        // Get XML URL - Assume xml is located on (name).utree/(name).xml
        // And put it in UsbongXMLParser
        let fileName = treeDirectoryURL.lastPathComponent?.componentsSeparatedByString(".").first ?? ""
        parser = UsbongXMLParser(contentsOfURL: treeDirectoryURL.URLByAppendingPathComponent("\(fileName).xml"))
        
        if let startNode = parser.fetchStartingTaskNode() {
            taskNodes.append(startNode)
        }
    }
    
    func transitionToNextTaskNode() {
    }
    func transitionToPreviousTaskNode() {
    }
}