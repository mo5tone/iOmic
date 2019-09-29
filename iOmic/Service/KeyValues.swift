//
//  KeyValues.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/11.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import MMKV

class KeyValues {
    static let shared: KeyValues = .init()
    private var mmkv: MMKV { return MMKV.default() }

    private init() {}

    func set(souce: Source, available: Bool) {
        mmkv.set(available, forKey: souce.rawValue)
    }

    func isAvailable(_ souce: Source) -> Bool {
        return mmkv.bool(forKey: souce.rawValue, defaultValue: true)
    }
}
