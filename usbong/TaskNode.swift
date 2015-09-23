//
//  TaskNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TaskNode {
    class var type: String { return "taskNode" }
    
    let modules: [TaskNodeModule]
    var transitionNamesAndToTaskNodeNames: [String: String] = [String: String]()
    
    init(modules: [TaskNodeModule]) {
        self.modules = modules
    }
    
}

extension TaskNode: Equatable {}
func ==(lhs: TaskNode, rhs: TaskNode) -> Bool {
    return lhs.modules == rhs.modules
}