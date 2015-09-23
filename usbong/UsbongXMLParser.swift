//
//  UsbongXMLParser.swift
//  usbong
//
//  Created by Chris Amanse on 9/16/15.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation
import SWXMLHash

class UsbongXMLParserID {
    static let processDefinition = "process-definition"
    static let startState = "start-state"
    static let taskNode = "task-node"
    static let transition = "transition"
    static let to = "to"
    static let name = "name"
}

class UsbongXMLNameComponents {
    let components: [String]
    init(name: String) {
        self.components = name.componentsSeparatedByString("~")
    }
    
    var type: String {
        return components.first ?? ""
    }
    
    var text: String {
        return components.last ?? ""
    }
    
    var imageFileName: String {
        guard components.count > 2 else {
            return ""
        }
        return components[1]
    }
    
    func imagePathUsingXMLURL(url: NSURL) -> String {
        if let rootURL = url.URLByDeletingLastPathComponent {
            let resURL = rootURL.URLByAppendingPathComponent("res")
            let imageURLWithoutExtension = resURL.URLByAppendingPathComponent(imageFileName)
            
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
            
            return imageURLWithoutExtension.URLByAppendingPathExtension(supportedImageFormats[0]).path ?? ""
        }
        return ""
    }
}

class UsbongXMLParser: NSObject {
    let url: NSURL
    var xml: XMLIndexer
    var processDefinition: XMLIndexer
    
    init(contentsOfURL: NSURL) {
        print("XML URL: \(contentsOfURL)")
        url = contentsOfURL
        xml = SWXMLHash.parse(NSData(contentsOfURL: contentsOfURL) ?? NSData())
        processDefinition = xml[UsbongXMLParserID.processDefinition]
        
        super.init()
    }
    
    func fetchStartingTaskNode() -> TaskNode? {
        if let element = processDefinition[UsbongXMLParserID.startState][UsbongXMLParserID.transition].element {
            if let name = element.attributes[UsbongXMLParserID.to] {
                return fetchTaskNodeWithName(name)
            }
        }
        return nil
    }
    func fetchTaskNodeWithName(name: String) -> TaskNode? {
        // Find task-node element with attribute name value
        guard (try? processDefinition[UsbongXMLParserID.taskNode].withAttr(UsbongXMLParserID.name, name)) != nil else {
            return nil
        }
        let taskNode: TaskNode?
        let nameComponents = UsbongXMLNameComponents(name: name)
        let type = nameComponents.type
        switch type {
        case TextDisplayTaskNode.type:
            taskNode =  TextDisplayTaskNode(text: nameComponents.text)
        case ImageDisplayTaskNode.type:
            taskNode =  ImageDisplayTaskNode(imageFilePath: nameComponents.imagePathUsingXMLURL(url))
        case TextImageDisplayTaskNode.type:
            taskNode = TextImageDisplayTaskNode(text: nameComponents.text, imageFilePath: nameComponents.imagePathUsingXMLURL(url))
        case ImageTextDisplayTaskNode.type:
            taskNode = ImageTextDisplayTaskNode(imageFilePath: nameComponents.imagePathUsingXMLURL(url), text: nameComponents.text)
        default:
            taskNode = nil
        }
        // Fetch transitions
        print(taskNode)
        print(try? processDefinition[UsbongXMLParserID.taskNode].withAttr(UsbongXMLParserID.name, name))
        return taskNode
    }
}
