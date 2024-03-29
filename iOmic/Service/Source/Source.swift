//
//  Source.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import FileKit
import Foundation
import Kingfisher
import RxSwift
import WCDBSwift

protocol SourceProtocol {
    var name: String { get }
    var imageDownloadRequestModifier: ImageDownloadRequestModifier { get }

    func fetchBooks(where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort) -> Single<[Book]>
    func fetchBook(where book: Book) -> Single<Book>
    func fetchChapters(where book: Book) -> Single<[Chapter]>
    func fetchPages(where chapter: Chapter) -> Single<[Page]>
}

enum Source: String, ColumnCodable, Differentiable {
    static var values: [Source] = [.dongmanzhijia, .manhuaren]

    case dongmanzhijia, manhuaren // JSON

    var instance: SourceProtocol {
        switch self {
        case .dongmanzhijia:
            return DongManZhiJia.shared
        case .manhuaren:
            return ManHuaRen.shared
        }
    }

    // MARK: - ColumnCodable

    static var columnType: ColumnType { return .text }
    func archivedValue() -> FundamentalValue { return FundamentalValue(rawValue) }
    init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }

    // MARK: - IdentifiableType

    typealias Identity = RawValue
    var identity: Identity { return rawValue }

    // MARK: - FetchingSort

    enum FetchingSort {
        case popularity, updatedDate
    }
}

extension Source: SourceProtocol {
    var name: String { return instance.name }
    var imageDownloadRequestModifier: ImageDownloadRequestModifier { return instance.imageDownloadRequestModifier }
    var available: Bool {
        set { KeyValues.shared.set(souce: self, available: newValue) }
        get { return KeyValues.shared.isAvailable(self) }
    }

    func fetchBooks(where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort) -> Single<[Book]> { return instance.fetchBooks(where: page, query: query, sortedBy: fetchingSort) }
    func fetchBook(where book: Book) -> Single<Book> { return instance.fetchBook(where: book) }
    func fetchChapters(where book: Book) -> Single<[Chapter]> { return instance.fetchChapters(where: book) }
    func fetchPages(where chapter: Chapter) -> Single<[Page]> { return instance.fetchPages(where: chapter) }
}
