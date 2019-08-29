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
import RxSwift

class Source: NSObject {
    enum Identifier: Int {
        static var values: [Identifier] = [.local, .dmzj, .manhuaren]
        // local
        case local = 0
        // online
        case dmzj, manhuaren // JSON
    }

    private var _available = true
    var available: Bool {
        get { return _available }
        set { _available = newValue }
    }
}

protocol SourceProtocol {
    var identifier: Source.Identifier { get }
    var name: String { get }
    var defaultFilters: [FilterProrocol] { get }
}

protocol OnlineSourceProtocol: SourceProtocol {
    func fetchBooks(page: Int, query: String, filters: [FilterProrocol]) -> Observable<[Book]>
    func fetchChapters(book: Book) -> Observable<[Chapter]>
    func fetchPages(chapter: Chapter) -> Observable<[Page]>
}

protocol LocalSourceProtocol: SourceProtocol {
    func booksOrder(by filters: [FilterProrocol]) -> [Path]
    func markBooks(_ books: [Path], unread: Bool)
    func pagesIn(book: Path) -> [Path]
}
