//
//  UsbongFileManager.swift
//  usbong
//
//  Created by Chris Amanse on 21/09/2015.
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
    var defaultFileName = "Unnamed"
    
    func contentsOfDirectoryAtRootURL() -> [NSURL]? {
        return try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(rootURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
    }
    
    func clearTemporaryDirectory() -> Bool {
        return (try? NSFileManager.defaultManager().removeItemAtURL(temporaryDirectoryURL)) != nil
    }
    
    func treesAtRootURL() -> [NSURL] {
        if let contents = contentsOfDirectoryAtRootURL() {
            // filter contents to URLs with path extension 'utree'
            return contents.filter({ $0.pathExtension == "utree" })
        }
        // Return empty array if contents is nil
        return []
    }
    
    func firstTreeInURL(url: NSURL) -> NSURL? {
        // Get directory of .utree folder in unpack directory
        let contents = try? NSFileManager.defaultManager().contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles)
        
        // Return first .utree found, else, return nil
        return contents?.filter({ $0.pathExtension == "utree" }).first ?? nil
    }
    
    func unpackTreeWithURL(url: NSURL, toDestinationURL destinationURL: NSURL) -> NSURL? {
        // Make sure tree URL is a file and destination url is a directory, else, return nil
//        if #available(iOS 9.0, *) {
//            guard !url.hasDirectoryPath && destinationURL.hasDirectoryPath else {
//                print("UsbongFileManager: Invalid URLs\nurl: \(url) \(url.fileURL)\ndestinationURL: \(destinationURL) \(destinationURL.fileURL)")
//                return nil
//            }
//        } else {
            // Fallback on earlier versions
//            print(url.path?.characters.last)
//            print(destinationURL.path?.characters.last)
//            guard url.path?[(url.path?.endIndex.predecessor())!] != "/" && destinationURL.path?[(destinationURL.path?.endIndex.predecessor())!] == "/" else {
//                print("UsbongFileManager: Invalid URLs\nurl: \(url) \ndestinationURL: \(destinationURL)")
//                return nil
//            }
//        }
        
        // Unpack
        if let zipPath = url.path, let destinationPath = destinationURL.path {
            guard ZipArchive.unzipFileAtPath(zipPath, toDestination: destinationPath) else {
                print("Failed to unzip")
                return nil
            }
            
            // Return first tree in unpacked directory
            return firstTreeInURL(destinationURL)
        }
        
        // If paths are nil, return nil
        print("UsbongFileManager: Paths are nil")
        return nil
    }
    
    func unpackTreeToTemporaryDirectoryWithTreeURL(treeURL: NSURL) -> NSURL? {
        // Make sure treeURL is a file, else, return nil
//        if #available(iOS 9.0, *) {
//            guard !treeURL.hasDirectoryPath else {
//                return nil
//            }
//        } else {
//            // Fallback on earlier versions
//            guard treeURL.path?.characters.last != "/" else {
//                return nil
//            }
//        }
        
        let md5 = NSData(contentsOfURL: treeURL)?.hashMD5() ?? "failedMD5"
        let unpackDirectoryURL = temporaryDirectoryURL.URLByAppendingPathComponent("\(md5)", isDirectory: true)
        
        // TODO: If temporary directory has lots of unpacked trees, delete all first
        
        // If unpack directory exists, it means, same file is already unpacked
        if NSFileManager.defaultManager().fileExistsAtPath(unpackDirectoryURL.path ?? "") {
            print("UsbongFileManager: Tree has already been unpacked before. Skipping unpack...")
            
            // Return first tree in unpacked directory
            return firstTreeInURL(unpackDirectoryURL)
        }
        print(unpackDirectoryURL.path)
        
        return unpackTreeWithURL(treeURL, toDestinationURL: unpackDirectoryURL)
    }
}