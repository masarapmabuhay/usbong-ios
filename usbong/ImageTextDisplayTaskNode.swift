//
//  ImageTextDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 19/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class ImageTextDisplayTaskNode: TaskNode {
    override class var type: String { return "imageTextDisplay" }
    
    init(imageFilePath: String, text: String) {
        let imageModule = ImageTaskNodeModule(imageFilePath: imageFilePath)
        let textModule = TextTaskNodeModule(text: text)
        super.init(modules: [imageModule, textModule])
    }
}