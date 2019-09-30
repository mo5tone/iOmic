//
//  KeyValues.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/11.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import MMKV

protocol KeyValuesProtocol: AnyObject {
    func set(souce: Source, available: Bool)
    func isAvailable(_ souce: Source) -> Bool
}

class KeyValues: KeyValuesProtocol {
    static let shared: KeyValues = .init()
    private let mmkv: MMKV

    private init() {
        mmkv = .default()
    }

    func set(souce: Source, available: Bool) {
        mmkv.set(available, forKey: souce.rawValue)
    }

    func isAvailable(_ souce: Source) -> Bool {
        return mmkv.bool(forKey: souce.rawValue, defaultValue: true)
    }
}
