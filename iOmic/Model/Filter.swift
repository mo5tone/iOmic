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

class PickFilter: FilterProrocol {
    let title: String
    let options: [(name: String, value: [String])]

    init(title: String, options: [(String, [String])]) {
        self.title = title
        self.options = options
    }

    init(title: String, options: [(String, String)]) {
        self.title = title
        self.options = options.map { ($0, [$1]) }
    }
}

class SinglePickFilter: PickFilter {
    var state: Int = 0

    var name: String { return options[state].name }
    var value: [String] { return options[state].value }
}

class MultiplePickFilter: PickFilter {
    var state: [Int] = []

    var names: [String] {
        return state.compactMap { index -> String? in
            guard index < options.count else { return nil }
            return options[index].name
        }
    }

    var values: [[String]] {
        return state.compactMap { index -> [String]? in
            guard index < options.count else { return nil }
            return options[index].value
        }
    }
}
