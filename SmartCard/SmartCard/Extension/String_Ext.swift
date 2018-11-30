//
//  String_Ext.swift
//  SmartCard
//
//  Created by archerLj on 2018/11/20.
//  Copyright © 2018 NoOrganization. All rights reserved.
//

import Foundation

extension String {
    static func className(cs: AnyClass) -> String {
        return NSStringFromClass(cs).components(separatedBy: ".").last!
    }
}

extension String {
    func getSha1() -> String {
        guard let data = self.data(using: .utf8) else {
            fatalError("Couldn't get data from this string")
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
        CC_SHA1(data.withUnsafeBytes { opendir($0) }, CC_LONG(data.count), &digest)
        
        var output = ""
        for byte in digest {
            let formated = String(format: "%02x", byte)
            output += formated
        }
        
        return output
    }
    
    func getMD5() -> String {
        let str = self.cString(using: .utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        var output = ""
        for i in 0..<digestLen {
            let str = String(format: "%02x", result[i])
            output.append(str)
        }
        
        result.deallocate()
        return output
    }
}
