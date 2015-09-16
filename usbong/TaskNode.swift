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
    var transitionNodesAndNames: [String: String] = [String : String]()
}