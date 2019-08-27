//
//  Chapter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class Chapter {
    // MARK: - props.

    let book: Book
    let url: String
    var name: String?
    var updateAt: Date?
    var chapterNumber: Double?

    // MARK: - public

    init(book: Book, url: String) {
        self.book = book
        self.url = url
    }
}
