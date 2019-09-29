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

    var differenceIdentifier: Book.DifferenceIdentifier { return identity }

    func isContentEqual(to source: Book) -> Bool {
        return thumbnailUrl == source.thumbnailUrl
            && title == source.title
            && artist == source.artist
            && author == source.author
            && genre == source.genre
            && summary == source.summary
            && status == source.status
            && isFavorited == source.isFavorited
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        // swiftlint:disable:next nesting
        typealias Root = Book
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, source, url, thumbnailUrl = "thumbnail_url", title, artist, author, genre, summary, status, isFavorited = "is_favorited", readAt = "read_at"
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - Status

    enum Status: String, ColumnCodable {
        case ongoing = "Ongoing"
        case completed = "Completed"
        case unknown = "Unknown"

        // MARK: - ColumnCodable

        static var columnType: ColumnType { return .text }
        func archivedValue() -> FundamentalValue { return FundamentalValue(rawValue) }
        init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }
    }

    // MARK: - Properties

    let identity: String
    let source: Source
    let url: String
    var thumbnailUrl: String?
    var title: String?
    var artist: String?
    var author: String?
    var genre: String?
    var summary: String?
    var status: Book.Status = .unknown
    var isFavorited: Bool = false
    var readAt: Date?

    // MARK: - Init

    init(source: Source, url: String) {
        self.source = source
        self.url = url
        identity = "\(source.rawValue)#\(url)"
    }
}
