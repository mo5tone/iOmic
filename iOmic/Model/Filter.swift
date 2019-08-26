//
//  Filter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class Filter<State: Hashable>: Equatable {
    static func == (lhs: Filter<State>, rhs: Filter<State>) -> Bool {
        return lhs.name == rhs.name && lhs.state.hashValue == rhs.state.hashValue
    }

    let name: String
    let state: State

    init(name: String, state: State) {
        self.name = name
        self.state = state
    }
}
