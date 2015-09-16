//
//  ImageDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class ImageDisplayNode: TaskNode {
    override class var type: String { return "imageDisplay" }
    
    var imageFileName: String {
        var components = name.componentsSeparatedByString("~")
        
        // Remove node type string
        components.removeFirst()
        
        return components.joinWithSeparator("~")
    }
}