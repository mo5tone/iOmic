//
//  DMZJSource.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class DMZJSource: OnlineSourceProtocol {
    // MARK: - OnlineSourceProtocol

    var identifier: SourceIdentifier = .dmzj

    var name: String { return "动漫之家" }

    func fetchBooksWhere(page _: Int, query _: String, filters _: [Filter]) -> [Book] {
        return []
    }

    func fetchChaptersIn(book _: Book) -> (book: Book, chapters: [Chapter]) {
        return (Book(), [])
    }

    func fetchPagesIn(chapter _: Chapter) -> (chapter: Chapter, pages: [Page]) {
        return (Chapter(), [])
    }

    // MARK: - Private

    // MARK: - Public
}
