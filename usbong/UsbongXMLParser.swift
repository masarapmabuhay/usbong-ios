//
//  UsbongXMLParser.swift
//  usbong
//
//  Created by Chris Amanse on 9/16/15.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class UsbongXMLParser: NSObject {
    private let parser: NSXMLParser?
    
    init(contentsOfURL: NSURL) {
        parser = NSXMLParser(contentsOfURL: contentsOfURL)
        
        super.init()
        
        parser?.delegate = self
    }
}

extension UsbongXMLParser: NSXMLParserDelegate {
    
}
