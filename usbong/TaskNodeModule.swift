//
//  TaskNodeModule.swift
//  usbong
//
//  Created by Chris Amanse on 23/09/2015.
//  Copyright 2015 Usbong Social Systems, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
