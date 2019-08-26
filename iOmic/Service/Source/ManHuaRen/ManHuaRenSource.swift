//
//  ManHuaRenSource.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class ManHuaRenSource: NSObject, OnlineSourceProtocol {
    // MARK: - Static

    static let shared = ManHuaRenSource()

    // MARK: - OnlineSourceProtocol

    var identifier: SourceIdentifier { return .manhuaren }

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

    private override init() {
        super.init()
    }

    // MARK: - Public
}
