//
//  MD5.swift
//  usbong
//
//  Created by Chris Amanse on 22/09/2015.
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