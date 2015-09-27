//
//  TaskNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TaskNode {
    // TODO: Don't put type in TaskNode. This is used only in XML parser, so put it there. (Even for subclasses)
    class var type: String { return "taskNode" }
    
    let modules: [TaskNodeModule]
    
    var backgroundAudioFilePath: String?
    
    var targetTransitionName: String?
    var transitionNamesAndToTaskNodeNames: [String: String] = [String: String]()
    
    init(modules: [TaskNodeModule]) {
        self.modules = modules
    }
}

extension TaskNode: Equatable {}
func ==(lhs: TaskNode, rhs: TaskNode) -> Bool {
    return lhs.modules == rhs.modules
}

class EndStateTaskNode: TaskNode {
    init(text: String) {
        let textModule = TextTaskNodeModule(text: text)
        super.init(modules: [textModule])
    }
}