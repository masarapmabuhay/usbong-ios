//
//  TaskNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

// TODO: Make usage of classes efficient and easy
class TaskNode {
    class var type: String { return "" }
    
    var name = ""
    var transitionNamesAndNodeNames: [String: String] = [String : String]()
}

protocol HasTextNode {
    var text: String { get }
}

extension HasTextNode where Self: TaskNode {
    var text: String {
        return name.componentsSeparatedByString("~").last ?? "" // Last component
    }
}

protocol HasImageNode {
    var imageFileName: String { get }
}

extension HasImageNode where Self: TaskNode {
    var imageFileName: String {
        return name.componentsSeparatedByString("~")[1] // Second component
    }
}