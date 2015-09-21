//
//  UsbongFileManager.swift
//  usbong
//
//  Created by Joe Amanse on 21/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

class UsbongFileManager {
    private static var _defaultManager = UsbongFileManager()
    static func defaultManager() -> UsbongFileManager {
        return UsbongFileManager._defaultManager
    }
    
    var rootURL: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    func fetchAllFileNamesAtRootURL() -> [String]? {
        return try? NSFileManager.defaultManager().contentsOfDirectoryAtPath(rootURL.path ?? "")
    }
    
    func getURLUsingRootURLAndFileName(fileName: String) -> NSURL {
        return rootURL.URLByAppendingPathComponent(fileName)
    }
}