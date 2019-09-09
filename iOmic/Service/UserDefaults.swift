//
//  UserDefaults.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DefaultsKit
import Foundation

extension DefaultsKey {
    static let sourceAvailability: Key<[String: Bool]> = .init("source_availability")
}
