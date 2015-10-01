//
//  TaskNode.swift
//  usbong
//
//  Created by Chris Amanse on 16/09/2015.
//  Copyright 2015 Usbong Social Systems, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

class TaskNode {
    // TODO: Don't put type in TaskNode. This is used only in XML parser, so put it there. (Even for subclasses)
    class var type: String { return "taskNode" }
    
    let modules: [TaskNodeModule]
    
    var backgroundAudioFilePath: String?
    var audioFilePath: String?
    
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