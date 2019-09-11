//
//  FiltersViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class FiltersViewModel: NSObject {
    let filters: [FilterProrocol]

    init(filters: [FilterProrocol]) {
        self.filters = filters.compactMap { $0.copy() as? FilterProrocol }
        super.init()
    }
}
