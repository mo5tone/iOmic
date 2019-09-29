//
//  Chapter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Foundation
import WCDBSwift

struct Chapter: Differentiable, TableCodable, ColumnJSONCodable {
    // MARK: - Differentiable

    typealias DifferenceIdentifier = String

    var differenceIdentifier: Chapter.DifferenceIdentifier { return identity }

    func isContentEqual(to source: Chapter) -> Bool {
        return name == source.name
            && updateAt == source.updateAt
            && chapterNumber == source.chapterNumber
            && download == source.download
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        // swiftlint:disable:next nesting
        typealias Root = Chapter
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, book, url, name, updateAt = "update_at", chapterNumber = "chapter_number", download
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - Download

    enum Download: String, ColumnCodable {
        case pending, running, paused, done, failed

        // MARK: - ColumnCodable

        static var columnType: ColumnType { return .text }
        func archivedValue() -> FundamentalValue { return .init(rawValue) }
        init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }
    }

    // MARK: - Properties

    let identity: String
    let book: Book
    let url: String
    var name: String?
    var updateAt: Date?
    var chapterNumber: Double?
    var download: Download?

    // MARK: - Init

    init(book: Book, url: String) {
        self.book = book
        self.url = url
        identity = "\(book.identity)#\(url)"
    }
}
