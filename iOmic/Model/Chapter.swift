//
//  Chapter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxDataSources
import WCDBSwift

struct Chapter: IdentifiableType, Equatable, TableCodable, ColumnJSONCodable {
    // MARK: - Type

    enum Download: String, ColumnCodable {
        case pending, running, paused, done, failed

        // MARK: - ColumnCodable

        static var columnType: ColumnType { return .text }
        func archivedValue() -> FundamentalValue { return .init(rawValue) }
        init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }
    }

    // MARK: - IdentifiableType

    typealias Identity = String
    let identity: Identity

    // MARK: - Equatable

    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs.book.identity == rhs.book.identity
            && lhs.url == rhs.url
            && lhs.name == rhs.name
            && lhs.updateAt == rhs.updateAt
            && lhs.chapterNumber == rhs.chapterNumber
            && lhs.download == rhs.download
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        // this refer WCDBSwift implement
        // swiftlint:disable:next nesting
        typealias Root = Chapter
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, book, url, name, updateAt = "update_at", chapterNumber = "chapter_number"
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - props.

    let book: Book
    let url: String
    var name: String?
    var updateAt: Date?
    var chapterNumber: Double?
    var download: Download?

    // MARK: - public

    init(book: Book, url: String) {
        self.book = book
        self.url = url
        identity = "\(book.identity)#\(url)"
    }
}
