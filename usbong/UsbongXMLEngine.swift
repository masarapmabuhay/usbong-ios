//
//  UsbongXMLEngine.swift
//  usbong
//
//  Created by Chris Amanse on 9/16/15.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation
import SWXMLHash

private struct UsbongXMLParserID {
    static let processDefinition = "process-definition"
    static let startState = "start-state"
    static let endState = "end-state"
    static let taskNode = "task-node"
    static let transition = "transition"
    static let to = "to"
    static let name = "name"
}

private struct UsbongXMLNameComponents {
    static var backgroundAudioIdentifier = "bgAudioName"
    static var audioIdentifier = "audioName"
    
    let components: [String]
    init(name: String) {
        self.components = name.componentsSeparatedByString("~")
    }
    
    var type: String {
        return components.first ?? ""
    }
    
    var text: String {
        // Parse new line strings and convert it to actual new lines
        return (components.last ?? "").stringByReplacingOccurrencesOfString("\\n", withString: "\n")
    }
    
    var imageFileName: String? {
        guard components.count >= 2 else {
            return nil
        }
        return components[1]
    }
    
    func imagePathUsingTreeURL(url: NSURL) -> String? {
        // Make sure imageFileName is nil, else, return nil
        guard imageFileName != nil else {
            return nil
        }
        
        let resURL = url.URLByAppendingPathComponent("res")
        let imageURLWithoutExtension = resURL.URLByAppendingPathComponent(imageFileName!)
        
        // Check for images with supported image formats
        let supportedImageFormats = ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "tif", "ico", "cur", "BMPf", "xbm"]
        let fileManager = NSFileManager.defaultManager()
        for format in supportedImageFormats {
            if let imagePath = imageURLWithoutExtension.URLByAppendingPathExtension(format).path {
                if fileManager.fileExistsAtPath(imagePath) {
                    return imagePath
                }
            }
        }
        
        return nil
    }
    
    // MARK: Background audio
    var backgroundAudioFileName: String? {
        let fullIdentifier = "@" + UsbongXMLNameComponents.backgroundAudioIdentifier + "="
        for component in components {
            if component.hasPrefix(fullIdentifier) {
                let startIndex = component.startIndex
                let endIndex = startIndex.advancedBy(fullIdentifier.characters.count)
                let range = Range(start: startIndex, end: endIndex)
                return component.stringByReplacingCharactersInRange(range, withString: "")
            }
        }
        return nil
    }
    func backgroundAudioPathUsingXMLURL(url: NSURL) -> String? {
        let audioURL = url.URLByAppendingPathComponent("audio")
        let targetFileName = backgroundAudioFileName
        
        // Finds files in audio/ with file name same to backgroundAudioFileName
        if let contents = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(audioURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
            for content in contents {
                if let fileName = content.URLByDeletingPathExtension?.lastPathComponent {
                    if fileName == targetFileName {
                        return content.path
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: Audio
    var audioFileName: String? {
        let fullIdentifier = "@" + UsbongXMLNameComponents.audioIdentifier + "="
        
        for component in components {
            if component.hasPrefix(fullIdentifier) {
                let startIndex = component.startIndex
                let endIndex = startIndex.advancedBy(fullIdentifier.characters.count)
                let range = Range(start: startIndex, end: endIndex)
                return component.stringByReplacingCharactersInRange(range, withString: "")
            }
        }
        return nil
    }
    func audioPathUsingXMLURL(url: NSURL) -> String? {
        let audioURL = url.URLByAppendingPathComponent("audio")
        let audioLanguageURL = audioURL.URLByAppendingPathComponent("English")
        let targetFileName = audioFileName
        
        // Find files in audio/{language} with file name same to audioFileName
        if let contents = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(audioLanguageURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
            for content in contents {
                if let fileName = content.URLByDeletingPathExtension?.lastPathComponent {
                    if fileName == targetFileName {
                        return content.path
                    }
                }
            }
        }
        
        return nil
    }
}

class UsbongTreeXMLEngine: NSObject, UsbongTreeEngine {
    let treeRootURL: NSURL
    let xmlURL: NSURL
    
    var xml: XMLIndexer
    var processDefinition: XMLIndexer
    
    init(treeRootURL: NSURL) {
        self.treeRootURL = treeRootURL
        
        let fileName = treeRootURL.lastPathComponent?.componentsSeparatedByString(".").first ?? ""
        xmlURL = treeRootURL.URLByAppendingPathComponent("\(fileName).xml")
        xml = SWXMLHash.parse(NSData(contentsOfURL: xmlURL) ?? NSData())
        processDefinition = xml[UsbongXMLParserID.processDefinition]
        
        super.init()
        
        tree = UsbongTree(treeEngine: self)
        
        // Set to "Unnamed" if fileName is black or contains spaces only
        tree.name = fileName.stringByReplacingOccurrencesOfString(" ", withString: "").characters.count == 0 ? "Unnamed" : fileName
    }
    
    // MARK: - UsbongTreeEngine
    
    private(set) var tree: UsbongTree = UsbongTree()
    
    func fetchStartingTaskNode() -> TaskNode? {
        if let element = processDefinition[UsbongXMLParserID.startState][UsbongXMLParserID.transition].element {
            if let name = element.attributes[UsbongXMLParserID.to] {
                return fetchTaskNodeWithName(name)
            }
        }
        return nil
    }
    
    func fetchTaskNodeWithName(name: String) -> TaskNode? {
        // task-node
        var taskNode: TaskNode?
        // Find task-node element with attribute name value
        if let taskNodeElement = try? processDefinition[UsbongXMLParserID.taskNode].withAttr(UsbongXMLParserID.name, name) {
            print(taskNodeElement)
            let nameComponents = UsbongXMLNameComponents(name: name)
            let type = nameComponents.type
            switch type {
            case TextDisplayTaskNode.type:
                taskNode =  TextDisplayTaskNode(text: nameComponents.text)
            case ImageDisplayTaskNode.type:
                taskNode =  ImageDisplayTaskNode(imageFilePath: nameComponents.imagePathUsingTreeURL(treeRootURL) ?? "")
            case TextImageDisplayTaskNode.type:
                taskNode = TextImageDisplayTaskNode(text: nameComponents.text, imageFilePath: nameComponents.imagePathUsingTreeURL(treeRootURL) ?? "")
            case ImageTextDisplayTaskNode.type:
                taskNode = ImageTextDisplayTaskNode(imageFilePath: nameComponents.imagePathUsingTreeURL(treeRootURL) ?? "", text: nameComponents.text)
            default:
                taskNode = nil
            }
            
            taskNode?.backgroundAudioFilePath = nameComponents.backgroundAudioPathUsingXMLURL(treeRootURL)
            taskNode?.audioFilePath = nameComponents.audioPathUsingXMLURL(treeRootURL)
            
            // Fetch transitions elements (<transition></transition>). For each transition, add to TaskNode transitions dictionary property.
            let transitionElements = taskNodeElement[UsbongXMLParserID.transition].all
            for transitionElement in transitionElements {
                if let attributes = transitionElement.element?.attributes {
                    // Get values of attributes name and to, add to taskNode object
                    let name = attributes["name"] ?? "Any" // Default is Any if no name found
                    taskNode?.transitionNamesAndToTaskNodeNames[name] = attributes["to"] ?? ""
                }
            }
            print("Transitions:\n\(taskNode?.transitionNamesAndToTaskNodeNames)")
            
            print(try? processDefinition[UsbongXMLParserID.taskNode].withAttr(UsbongXMLParserID.name, name))
            return taskNode
        } else if let endStateElement = try? processDefinition[UsbongXMLParserID.endState].withAttr(UsbongXMLParserID.name, name) {
            // Find end-state node if task-node not found
            print(endStateElement)
            taskNode =  EndStateTaskNode(text: "You've now reached the end")
        }
        
        return taskNode
    }
}
