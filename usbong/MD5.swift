//
//  MD5.swift
//  usbong
//
//  Created by Joe Amanse on 22/09/2015.
//  Copyright © 2015 Joe Christopher Paul Amanse. All rights reserved.
//

import Foundation

// CommonCrypto required (Objective-C library, thus you need to use bridging header
extension NSData {
    func hashMD5() -> String {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CC_MD5(bytes, CC_LONG(length), md5Buffer)
        
        let hash = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH * 2))
        for i in 0..<digestLength {
            hash.appendFormat("%02x", md5Buffer[i])
        }
        
        md5Buffer.destroy()
        
        return String(hash)
    }
}

extension String {
    func hashMD5() -> String {
        let utf8 = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let stringLength = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLength)
        
        CC_MD5(utf8!, stringLength, md5Buffer)
        
        let hash = NSMutableString()
        for i in 0..<digestLength {
            hash.appendFormat("%02x", md5Buffer[i])
        }
        
        md5Buffer.destroy()
        
        return String(hash)
    }
}