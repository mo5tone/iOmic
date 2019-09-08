//
//  Page.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxDataSources

struct Page {
    // MARK: - props.

    let chapter: Chapter
    let index: Int
    var url: String?
    var imageURL: String?

    // MARK: - public

    init(chapter: Chapter, index: Int) {
        self.chapter = chapter
        self.index = index
    }
}

// MARK: - Equatable, IdentifiableType

extension Page: Equatable, IdentifiableType {
    typealias Identity = String
    var identity: Identity { return "\(chapter.identity)#\(index)" }

    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.chapter == rhs.chapter
            && lhs.index == rhs.index
            && lhs.url == rhs.url
            && lhs.imageURL == rhs.imageURL
    }
}
