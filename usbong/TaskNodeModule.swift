//
//  TaskNodeModule.swift
//  usbong
//
//  Created by Joe Amanse on 23/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class TaskNodeModule {
    var content: [String: NSObject]
    
    init(content: [String: NSObject]) {
        self.content = content
    }
}

extension TaskNodeModule: Equatable {}
func ==(lhs: TaskNodeModule, rhs: TaskNodeModule) -> Bool {
    return lhs.content == rhs.content
}

class TextTaskNodeModule: TaskNodeModule {
    init(text: String) {
        let dict: [String: NSObject] = [ "text": NSString(string: text) ]
        super.init(content: dict)
    }
    var text: String {
        get {
            return ((content["text"] as? NSString) ?? "") as String
        }
        set {
            content["text"] = NSString(string: newValue)
        }
    }
}

class ImageTaskNodeModule: TaskNodeModule {
    init(imageFilePath: String) {
        let dict: [String: NSObject] = [ "imageFilePath": NSString(string: imageFilePath)]
        super.init(content: dict)
    }
    var imageFilePath: String {
        get {
            return ((content["imageFilePath"] as? NSString) ?? "") as String
        }
        set {
            content["imageFilePath"] = NSString(string: newValue)
        }
    }
}
