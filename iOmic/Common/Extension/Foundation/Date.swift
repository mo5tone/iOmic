//
//  Date.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/28.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

extension Date {
    /// convert to String
    ///
    func convert2String(dateFormat: String = "yyyy-MM-dd+HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
