//
//  TaskNodeModule.swift
//  usbong
//
//  Created by Joe Amanse on 23/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TaskNodeModule {
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

extension TaskNodeModule: Equatable {}
func ==(lhs: TaskNodeModule, rhs: TaskNodeModule) -> Bool {
    return lhs.content == rhs.content
}

class TextTaskNodeModule: TaskNodeModule {
    init(text: String) {
        super.init(content: text)
    }
    var text: String {
        get {
            return content
        }
        set {
            content = newValue
        }
    }
}

class ImageTaskNodeModule: TaskNodeModule {
    init(imageFilePath: String) {
        super.init(content: imageFilePath)
    }
    var imageFilePath: String {
        get {
            return content
        }
        set {
            content = newValue
        }
    }
}
