//
//  Filter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

protocol FilterProrocol: NSCopying {
    var title: String { get }
}

class ToggleFilter: FilterProrocol {
    let title: String
    var state: Bool = false

    required init(title: String) {
        self.title = title
    }

    // MARK: - NSCopying

    func copy(with _: NSZone? = nil) -> Any {
        let copy = type(of: self).init(title: title)
        copy.state = state
        return copy
    }
}

class PickFilter: FilterProrocol {
    let title: String
    let options: [(name: String, value: [String])]

    required init(title: String, options: [(String, [String])]) {
        self.title = title
        self.options = options
    }

    convenience init(title: String, options: [(String, String)]) {
        self.init(title: title, options: options.map { ($0, [$1]) })
    }

    // MARK: - NSCopying

    func copy(with _: NSZone? = nil) -> Any {
        let copy = type(of: self).init(title: title, options: options)
        return copy
    }
}

class SinglePickFilter: PickFilter {
    var state: Int = 0

    var name: String { return options[state].name }
    var value: [String] { return options[state].value }

    // MARK: - NSCopying

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? SinglePickFilter
        copy?.state = state
        return copy ?? self
    }
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

    // MARK: - NSCopying

    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? MultiplePickFilter
        copy?.state = state
        return copy ?? self
    }
}
