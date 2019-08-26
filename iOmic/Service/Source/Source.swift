//
//  Source.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import FileKit
import Foundation

enum SourceIdentifier {
    static let values: [SourceIdentifier] = [local, dmzj, manhuaren]
    // local source
    case local
    // online source
    case dmzj, manhuaren // JSON
}

protocol SourceProtocol {
    var identifier: SourceIdentifier { get }
    var name: String { get }
}

protocol OnlineSourceProtocol: SourceProtocol {
    func fetchBooksWhere(page: Int, query: String, filters: [Filter]) -> [Book]
    func fetchChaptersIn(book: Book) -> (book: Book, chapters: [Chapter])
    func fetchPagesIn(chapter: Chapter) -> (chapter: Chapter, pages: [Page])
}

protocol LocalSourceProtocol: SourceProtocol {
    func booksOrder(by filters: [Filter]) -> [Path]
    func markBooks(_ books: [Path], unread: Bool)
    func pagesIn(book: Path) -> [Path]
}
