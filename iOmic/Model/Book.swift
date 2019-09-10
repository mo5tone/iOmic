//
//  Book.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxDataSources
import UIKit
import WCDBSwift

struct Book: IdentifiableType, Equatable, TableCodable, ColumnJSONCodable {
    // MARK: - IdentifiableType

    typealias Identity = String
    let identity: Identity

    // MARK: - Equatable

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.source.identifier == rhs.source.identifier
            && lhs.url == rhs.url
            && lhs.thumbnailUrl == rhs.thumbnailUrl
            && lhs.title == rhs.title
            && lhs.artist == rhs.artist
            && lhs.author == rhs.author
            && lhs.genre == rhs.genre
            && lhs.summary == rhs.summary
            && lhs.status == rhs.status
            && lhs.isFavorited == rhs.isFavorited
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Book
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, sourceIdentifier = "source_identifier", url, thumbnailUrl = "thumbnail_url", title, artist, author, genre, summary, status, isFavorited = "is_favorited", readAt = "read_at"
        static var columConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - types

    enum Status: String, ColumnCodable {
        case ongoing = "Ongoing"
        case completed = "Completed"
        case unknown = "Unknown"
        static var columnType: ColumnType { return .text }
        func archivedValue() -> FundamentalValue { return FundamentalValue(rawValue) }
        init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }
    }

    // MARK: - props.

    let sourceIdentifier: SourceIdentifier
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
    var source: SourceProtocol { return sourceIdentifier.source }

    // MARK: - methods

    init(source: SourceProtocol, url: String) {
        sourceIdentifier = source.identifier
        self.url = url
        identity = "\(source.identifier.rawValue)#\(url)"
    }
}
