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
    var name: String = ""
    
    var language: String = "English"
    
    weak var treeEngine: UsbongTreeEngine? {
        didSet {
            taskNodes = []
            loadStartingTreeFromEngine()
        }
    }
    
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
    
    convenience init() {
        self.init(treeEngine: nil)
    }
    init(treeEngine: UsbongTreeEngine?) {
        self.treeEngine = treeEngine
        
        loadStartingTreeFromEngine()
    }
    
    private func loadStartingTreeFromEngine() {
        // Fetch starting task node
        if let startNode = treeEngine?.fetchStartingTaskNode() {
            taskNodes.append(startNode)
        }
    }
    
    func nextTaskNodeWithTransitionName(transitionName: String) -> TaskNode? {
        if let current = currentTaskNode {
            if let taskNodeName = current.transitionNamesAndToTaskNodeNames[transitionName] {
                return treeEngine?.fetchTaskNodeWithName(taskNodeName)
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

protocol UsbongTreeEngine: class {
    var tree: UsbongTree { get }
    
    func fetchStartingTaskNode() -> TaskNode?
    func fetchTaskNodeWithName(name: String) -> TaskNode?
}