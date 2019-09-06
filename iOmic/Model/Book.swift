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

struct Book {
    enum Status {
        case ongoing
        case completed
        case unknown

        var name: String {
            switch self {
            case .ongoing:
                return "Ongoing"
            case .completed:
                return "Completed"
            case .unknown:
                return "Unknown"
            }
        }
    }

    // MARK: - props.

    let source: OnlineSourceProtocol
    let url: String
    var thumbnailUrl: String?
    var title: String?
    var artist: String?
    var author: String?
    var genre: String?
    var description: String?
    var status: Status = .unknown

    // MARK: - public

    init(source: OnlineSourceProtocol, url: String) {
        self.source = source
        self.url = url
    }
}

// MARK: - Book.Status CustomStringConvertible

extension Book.Status: CustomStringConvertible {
    var description: String {
        switch self {
        case .ongoing:
            return "Ongoing"
        case .completed:
            return "Completed"
        case .unknown:
            return "Unknown"
        }
    }
}

extension Book: Equatable, IdentifiableType {
    typealias Identity = String
    var identity: Identity {
        return "\(source.identifier.rawValue)#\(url)"
    }

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
