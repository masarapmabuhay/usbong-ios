//
//  ImageDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class ImageDisplayTaskNode: TaskNode {
    override class var type: String { return "imageDisplay" }
    
    init(imageFilePath: String) {
        let imageModule = ImageTaskNodeModule(imageFilePath: imageFilePath)
        super.init(modules: [imageModule])
    }
}