//
//  Book.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class Book {
    enum Status {
        case inProgress
        case complete
        case unknown
    }

    // MARK: - props.

    let identifier: Source.Identifier
    let url: String
    var thumbnailUrl: String?
    var title: String?
    var artist: String?
    var author: String?
    var genre: String?
    var description: String?
    var status: Status = .unknown

    // MARK: - public

    init(identifier: Source.Identifier, url: String) {
        self.identifier = identifier
        self.url = url
    }
}

// MARK: - Book.Status CustomStringConvertible

extension Book.Status: CustomStringConvertible {
    var description: String {
        switch self {
        case .inProgress:
            return "in progress"
        case .complete:
            return "complete"
        case .unknown:
            return "unknown"
        }
    }
}
