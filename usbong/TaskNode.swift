//
//  TaskNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

enum Module {
    case Text
    case Image
}

// TODO: Order of modules?
class TaskNode {
    class var type: String { return "" }
    
    var name = ""
    var modules: [Module] { return [] }
    var transitionNamesAndNodeNames: [String: String] = [String : String]()
}

protocol HasTextModule {
    var text: String { get }
}

// Default implementation of text
extension HasTextModule where Self: TaskNode {
    var text: String {
        return name.componentsSeparatedByString("~").last ?? "" // Last component
    }
}

protocol HasImageModule {
    var imageFileName: String { get }
}

// Default implementation of image file name
extension HasImageModule where Self: TaskNode {
    var imageFileName: String {
        return name.componentsSeparatedByString("~")[1] // Second component
    }
}