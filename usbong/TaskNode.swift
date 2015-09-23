//
//  TaskNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

// Modules - used for ordering
//enum TaskNodeModule {
//    case Text
//    case Image
//}

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

//struct


//class TaskNode {
//    class var type: String { return "" }
//    
//    /**
//    Name with format:
//    
//    *taskNodeType~imageIfApplicable~otherStuff~textIfApplicable*.
//    */
//    var name = ""
//    var modules: [TaskNodeModule] { return [] }
//    var transitionNamesAndTaskNodeNames: [String: String] = [String : String]()
//    
//    init() {}
//    init(name: String) {
//        self.name = name
//    }
//    
//    /**
//    Create a `TaskNode` based on name.
//    
//    - parameters:
//      - name: Name with format:
//
//        *taskNodeType~imageIfApplicable~otherStuff~textIfApplicable*.
//    - returns: Returns nil if unrecognized type. Else, returns the appropriate TaskNode subclass
//    */
//    static func taskNodeFromName(name: String) -> TaskNode? {
//        // Determine subclass based on first component of name (i.e. "textDisplay~Scene 1~This is the text")
//        let typeString = name.componentsSeparatedByString("~").first ?? ""
//        switch typeString {
//        case TextDisplayNode.type:
//            return TextDisplayNode(name: name)
//        case ImageDisplayNode.type:
//            return ImageDisplayNode(name: name)
//        case TextImageDisplayNode.type:
//            return TextImageDisplayNode(name: name)
//        case ImageTextDisplayNode.type:
//            return ImageTextDisplayNode(name: name)
//        default:
//            return nil
//        }
//    }
//}
//
//// Task node name and modules determine equality. Transitions don't affect equality.
//extension TaskNode: Equatable {}
//func ==(lhs: TaskNode, rhs: TaskNode) -> Bool {
//    return lhs.name == rhs.name && lhs.modules == rhs.modules
//}
//
//protocol HasTextModule {
//    var text: String { get }
//}
//
//// Default implementation of text
//extension HasTextModule where Self: TaskNode {
//    var text: String {
//        return name.componentsSeparatedByString("~").last ?? "" // Last component
//    }
//}
//
//protocol HasImageModule {
//    var imageFileName: String { get }
//}
//
//// Default implementation of image file name
//extension HasImageModule where Self: TaskNode {
//    var imageFileName: String {
//        return name.componentsSeparatedByString("~")[1] // Second component
//    }
//}