//
//  String.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import typealias CommonCrypto.CC_LONG
import func CommonCrypto.CC_MD5
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import DifferenceKit
import Foundation

extension String: Differentiable {}

extension String {
    /// Source Helper: scheme fixer
    ///
    func fixScheme(_ scheme: String = "http") -> String {
        if starts(with: "//") { return "\(scheme):\(self)" }
        return self
    }

    /// convert to Date
    ///
    func convert2Date(dateFormat: String = "yyyy-MM-dd+HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }

    /// MD5 data
    var md5Data: Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = data(using: .utf8)!
        var digestData = Data(count: length)
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }

    /// MD5 String
    ///
    func md5String(upperCase: Bool = false) -> String {
        let format = "%02hh\(upperCase ? "X" : "x")"
        return md5Data.map { String(format: format, $0) }.joined()
    }
}
