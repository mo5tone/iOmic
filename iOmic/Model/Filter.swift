//
//  Filter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class Filter {
    // MARK: - instance

    let title: String
    let keyValues: [(key: String, value: String)]
    private var _index: Int = 0
    var index: Int {
        get { return _index }
        set { _index = max(0, min(newValue, keyValues.count - 1)) }
    }

    var key: String { return keyValues[index].key }
    var value: String { return keyValues[index].value }

    // MARK: - public

    init(title: String, keyValues: [(key: String, value: String)], index: Int = 0) {
        assert(!title.isEmpty)
        assert(!keyValues.isEmpty)
        self.title = title
        self.keyValues = keyValues
        self.index = index
    }
}
