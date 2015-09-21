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
        // Default root URL is App's Documents folder
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    var temporaryDirectoryURL = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).URLByAppendingPathComponent("trees", isDirectory: true)
    
    func contentsOfDirectoryAtRootURL() -> [NSURL]? {
        return try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(rootURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
    }
    
    func treesAtRootURL() -> [NSURL] {
        if let contents = contentsOfDirectoryAtRootURL() {
            // filter contents to URLs with path extension 'utree'
            return contents.filter({ $0.pathExtension == "utree" })
        }
        // Return empty array if contents is nil
        return []
    }
    
    var defaultFileName = "Unnamed"
    
    func unpackTreeWithURL(url: NSURL, toDestinationURL destinationURL: NSURL) -> Bool {
        // Make sure tree URL is a file and destination url is a directory, else, return false
        guard url.fileURL && !destinationURL.fileURL else {
            return false
        }
        
        // Unpack code here
        
        return true
    }
    
    func unpackTreeToTemporaryDirectoryWithTreeURL(treeURL: NSURL) -> Bool {
        // Make sure treeURL is a file, else, return false
        guard treeURL.fileURL else {
            return false
        }
        
        print("TemporaryDirectoryURL: \(temporaryDirectoryURL)")
        
        // If tempDirectoryURL does not exist or is not a directory, create directory
        var isDirectory: ObjCBool = true
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(temporaryDirectoryURL.path ?? "", isDirectory: &isDirectory) || !isDirectory {
            print("Temp directory does not exist")
            do {
                try fileManager.createDirectoryAtURL(temporaryDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                print("Created temporary directory")
            } catch {
                return false
            }
        }
        
        return unpackTreeWithURL(treeURL, toDestinationURL: temporaryDirectoryURL)
    }
}