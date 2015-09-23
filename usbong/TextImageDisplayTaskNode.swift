//
//  TextImageDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TextImageDisplayTaskNode: TaskNode {
    override class var type: String { return "textImageDisplay" }
    
    init(text: String, imageFilePath: String) {
        let textModule = TextTaskNodeModule(text: text)
        let imageModule = ImageTaskNodeModule(imageFilePath: imageFilePath)
        super.init(modules: [textModule, imageModule])
    }
}