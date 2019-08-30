//
//  Filter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

protocol FilterProrocol {
    var title: String { get }
}

class ToggleFilter: FilterProrocol {
    let title: String
    var state: Bool

    init(title: String, state: Bool = false) {
        self.title = title
        self.state = state
    }
}

class PickFilter<ValueType>: FilterProrocol {
    let title: String
    var state: Int
    let options: [(name: String, value: ValueType)]

    var name: String { return options[state].name }
    var value: ValueType { return options[state].value }

    init(title: String, options: [(String, ValueType)], state: Int = 0) {
        self.title = title
        self.options = options
        self.state = state
    }
}

class MultiplePickFilter<ValueType>: FilterProrocol {
    let title: String
    var state: [Int]
    let options: [(name: String, value: ValueType)]

    var values: [ValueType] {
        return state.compactMap { index -> ValueType? in
            guard index < options.count else { return nil }
            return options[index].value
        }
    }

    init(title: String, options: [(String, ValueType)], state: [Int] = []) {
        self.title = title
        self.options = options
        self.state = state
    }
}
