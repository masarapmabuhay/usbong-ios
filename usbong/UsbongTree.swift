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
    private(set) var parser: UsbongXMLParser
    
    // Task Nodes
    private(set) var taskNodes: [TaskNode] = []
    var currentTaskNode: TaskNode? {
        return taskNodes.last
    }
    var nextTaskNode: TaskNode? {
        return nextTaskNodeWithTransitionName(currentTaskNode?.targetTransitionName ?? "Any")
    }
    var previousTaskNode: TaskNode? {
        guard taskNodes.count > 1 else {
            return nil
        }
        return taskNodes[taskNodes.count - 2]
    }
    
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
    
    func nextTaskNodeWithTransitionName(transitionName: String) -> TaskNode? {
        if let current = currentTaskNode {
            if let taskNodeName = current.transitionNamesAndToTaskNodeNames[transitionName] {
                return parser.fetchTaskNodeWithName(taskNodeName)
            }
        }
        return nil
    }
    
    func transitionToNextTaskNode() -> Bool {
        if let next = nextTaskNode {
            taskNodes.append(next)
            return true
        }
        return false
    }
    func transitionToNextTaskNodeWithTransitionName(transitionName: String) -> Bool {
        if let next = nextTaskNodeWithTransitionName(transitionName) {
            taskNodes.append(next)
            return true
        }
        return false
    }
    func transitionToPreviousTaskNode() -> Bool {
        if taskNodes.count > 1 {
            taskNodes.removeLast()
            return true
        }
        return false
    }
}