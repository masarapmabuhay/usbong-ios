//
//  TextDisplayNode.swift
//  usbong
//
//  Created by Joe Amanse on 16/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

//class TextDisplayNode: TaskNode, HasTextModule {
//    override class var type: String { return "textDisplay" }
//    
//    override var modules: [TaskNodeModule] { return [.Text] }
//}

class TextDisplayTaskNode: TaskNode {
    override class var type: String { return "textDisplay" }
    
    init(text: String) {
        let textModule = TextTaskNodeModule(text: text)
        super.init(modules: [textModule])
    }
}