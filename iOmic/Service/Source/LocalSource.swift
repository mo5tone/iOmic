//
//  LocalSource.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/30.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FileKit
import Foundation

class LocalSource: Source {
    // MARK: - Static

    static let shared = LocalSource()

    // MARK: - props.

    // MARK: - Private

    private override init() {
        super.init()
    }
}

// MARK: - LocalSourceProtocol

extension LocalSource: LocalSourceProtocol {
    var name: String {
        return "本地"
    }

    var defaultFilters: [FilterProrocol] {
        return [SortFilter()]
    }

    func booksOrder(by _: [FilterProrocol]) -> [Path] {
        // TODO: -
        return []
    }

    func markBooks(_: [Path], unread _: Bool) {
        // TODO: -
    }

    func pagesIn(book _: Path) -> [Path] {
        // TODO: -
        return []
    }

    var identifier: Source.Identifier {
        return .local
    }
}

extension LocalSource {
    class SortFilter: SinglePickFilter {
        init() {
            super.init(title: "排序", options: [("名称", "0"), ("大小", "1"), ("时间", "2")])
        }
    }
}
