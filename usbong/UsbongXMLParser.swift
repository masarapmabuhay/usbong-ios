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

class UsbongXMLParser: NSObject {
    var xml: XMLIndexer
    var processDefinition: XMLIndexer
    
    init(contentsOfURL: NSURL) {
        print("XML URL: \(contentsOfURL)")
        xml = SWXMLHash.parse(NSData(contentsOfURL: contentsOfURL) ?? NSData())
        processDefinition = xml[UsbongXMLParserID.processDefinition]
        
        super.init()
        
        fetchStartingTaskNode()
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
        if let element = try? processDefinition[UsbongXMLParserID.taskNode].withAttr(UsbongXMLParserID.name, name) {
            print(element)
            if let taskNode = TaskNode.taskNodeFromName(name) {
                print(taskNode)
                // Get transition tos and names from element
                
                return taskNode
            }
        }
        return nil
    }
}

/*
extension UsbongXMLParser: NSXMLParserDelegate {
    func parserDidStartDocument(parser: NSXMLParser) {
        print("Started parsing")
    }
    func parserDidEndDocument(parser: NSXMLParser) {
        print("Ended parsing")
    }
    
    func parser(parser: NSXMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
        print("found notation declaration with name publicID systemID:\(name)\n\(publicID)\n\(systemID)")
    }
    
    func parser(parser: NSXMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        print("found unparsed entity declaration with name publicID systemID notationName:\(name)\n\(publicID)\n\(systemID)\n\(notationName)")
    }
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        print("found attribute declaration with attributeName elementName type defaultValue:\(attributeName)\n\(elementName)\n\(type)\n\(defaultValue))")
    }
    
//    func parser(parser: NSXMLParser, foundElementDeclarationWithName elementName: String, model: String)
//    func parser(parser: NSXMLParser, foundInternalEntityDeclarationWithName name: String, value: String?)
//    func parser(parser: NSXMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?)
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("DidStartElement: \(elementName)\n\tNamespace: \(namespaceURI)\n\tQualifiedName: \(qName)\n\tattributes: \(attributeDict)")
    }
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("DidEndElement: \(elementName)\n\tNamespace: \(namespaceURI)\n\tQualifiedName: \(qName)\n")
    }
//    func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String)
//    func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String)
//    func parser(parser: NSXMLParser, foundCharacters string: String)
//    func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String)
//    func parser(parser: NSXMLParser, foundProcessingInstructionWithTarget target: String, data: String?)
//    func parser(parser: NSXMLParser, foundComment comment: String)
//    func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData)
//    func parser(parser: NSXMLParser, resolveExternalEntityName name: String, systemID: String?) -> NSData?
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("parseErrorOccured: \(parseError)")
    }
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("validationErrorOccured: \(validationError)")
    }
}
*/
