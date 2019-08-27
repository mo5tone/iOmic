//
//  Page.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class Page {
    // MARK: - props.

    let chapter: Chapter
    var index: Int = 0
    var url: String?
    var imageURL: String?

    // MARK: - public

    init(chapter: Chapter) {
        self.chapter = chapter
    }
}
