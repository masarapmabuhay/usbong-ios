//
//  TextImageDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TextImageDisplayNode: ImageDisplayNode {
    override class var type: String { return "textImageDisplay" }
    
    override var imageFileName: String {
        return name.componentsSeparatedByString("~")[1]
    }
    
    var text: String {
        var components = name.componentsSeparatedByString("~")
        
        // Remove node type string
        components.removeFirst()
        components.removeFirst()
        
        return components.joinWithSeparator("~")
    }
}