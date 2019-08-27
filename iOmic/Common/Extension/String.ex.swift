//
//  String.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

extension String {
    func fixScheme(_ scheme: String = "http") -> String {
        if starts(with: "//") { return "\(scheme):\(self)" }
        return self
    }
}
