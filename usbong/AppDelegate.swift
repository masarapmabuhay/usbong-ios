//
//  AppDelegate.swift
//  usbong
//
//  Created by Joe Amanse on 15/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UsbongFileManager.defaultManager().clearTemporaryDirectory()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(url)
        // Copy .utree to rootURL
        if let fileNameExtension = url.pathExtension, let fileName = url.URLByDeletingPathExtension?.lastPathComponent {
            guard fileNameExtension == "utree" else {
                return false
            }
            
            let rootURL = UsbongFileManager.defaultManager().rootURL
            let defaultManager = NSFileManager.defaultManager()
            
            var count = 0
            var newURL = rootURL
            repeat {
                let suffix = count == 0 ? "" : "-\(count)"
                newURL = rootURL.URLByAppendingPathComponent("\(fileName)\(suffix)").URLByAppendingPathExtension(fileNameExtension)
                count++
            } while defaultManager.fileExistsAtPath(newURL.path ?? "")
            
            print(newURL.path)
            
            let success = (try? defaultManager.moveItemAtURL(url, toURL: newURL)) != nil
            
            // DEBUG: Remove contents of inbox
//            if let inboxURL = rootURL.URLByDeletingLastPathComponent {
//                if let contents = try? defaultManager.contentsOfDirectoryAtURL(inboxURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants) {
//                    for content in contents {
//                        try? defaultManager.removeItemAtPath(content.path ?? "")
//                    }
//                }
//            }
            
            if success {
                NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationLaunchOptionsURLKey, object: nil)
            }
            return success
        }
        
        
        return false
    }
}

