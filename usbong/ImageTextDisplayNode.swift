//
//  ImageTextDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 19/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class ImageTextDisplayNode: TaskNode, HasTextModule, HasImageModule {
    override class var type: String { return "imageTextDisplay" }
    
    override var modules: [Module] { return [.Image, .Text] }
}