//
//  Book.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources
import UIKit

class Book {
    // MARK: - types

    enum Status: String {
        case ongoing = "Ongoing"
        case completed = "Completed"
        case unknown = "Unknown"
    }

    // MARK: - props.

    let source: SourceProtocol
    let url: String
    var thumbnailUrl: String?
    var title: String?
    var artist: String?
    var author: String?
    var genre: String?
    var description: String?
    var status: Book.Status = .unknown

    // MARK: - methods

    init(source: SourceProtocol, url: String) {
        self.source = source
        self.url = url
    }
}

// MARK: - Equatable, IdentifiableType

extension Book: Equatable, IdentifiableType {
    typealias Identity = String
    var identity: Identity { return "\(source.identifier.rawValue)#\(url)" }

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.source.identifier == rhs.source.identifier
            && lhs.url == rhs.url
            && lhs.thumbnailUrl == rhs.thumbnailUrl
            && lhs.title == rhs.title
            && lhs.artist == rhs.artist
            && lhs.author == rhs.author
            && lhs.genre == rhs.genre
            && lhs.description == rhs.description
            && lhs.status == rhs.status
    }
}
