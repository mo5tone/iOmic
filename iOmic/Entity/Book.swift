//
//  Book.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Foundation
import UIKit
import WCDBSwift

struct Book: Differentiable, TableCodable, ColumnJSONCodable {
    // MARK: - Differentiable

    typealias DifferenceIdentifier = String

    var differenceIdentifier: Book.DifferenceIdentifier { return "\(source.rawValue)#\(url)" }

    func isContentEqual(to source: Book) -> Bool {
        return thumbnailUrl == source.thumbnailUrl
            && title == source.title
            && artist == source.artist
            && author == source.author
            && genre == source.genre
            && summary == source.summary
            && serialState == source.serialState
            && isFavorite == source.isFavorite
            && readAt == source.readAt
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        // swiftlint:disable:next nesting
        typealias Root = Book
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case source, url, thumbnailUrl = "thumbnail_url", title, artist, author, genre, summary, serialState = "serial_state", isFavorite = "is_favorite", readAt = "read_at"
        static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
            return [
                "multiPrimaryBinding": MultiPrimaryBinding(indexesBy: [source, url], onConflict: .replace),
            ]
        }
    }

    // MARK: - SerialState

    enum SerialState: String, ColumnCodable {
        case ongoing = "Ongoing"
        case completed = "Completed"
        case unknown = "Unknown"

        // MARK: - ColumnCodable

        static var columnType: ColumnType { return .text }
        func archivedValue() -> FundamentalValue { return .init(rawValue) }
        init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }
    }

    // MARK: - Properties

    let source: Source
    let url: String
    var thumbnailUrl: String?
    var title: String?
    var artist: String?
    var author: String?
    var genre: String?
    var summary: String?
    var serialState: Book.SerialState = .unknown
    var isFavorite: Bool = false
    var readAt: Date?

    // MARK: - Init

    init(source: Source, url: String) {
        self.source = source
        self.url = url
    }
}
