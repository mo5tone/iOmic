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

class Book: Object {
    // MARK: - types

    enum Status: String {
        case ongoing = "Ongoing"
        case completed = "Completed"
        case unknown = "Unknown"
    }

    // MARK: - props.

    @objc private dynamic var _sourceIdentifier: String = SourceIdentifier.values[0].rawValue
    @objc dynamic var url: String = ""
    @objc dynamic var thumbnailUrl: String?
    @objc dynamic var title: String?
    @objc dynamic var artist: String?
    @objc dynamic var author: String?
    @objc dynamic var genre: String?
    @objc dynamic var summary: String?
    @objc private dynamic var _status: String = Book.Status.unknown.rawValue
    var source: SourceProtocol { return sourceIdentifier.source }
    var sourceIdentifier: SourceIdentifier {
        get { return SourceIdentifier(rawValue: _sourceIdentifier) ?? SourceIdentifier.values[0] }
        set { _sourceIdentifier = newValue.rawValue }
    }

    var status: Book.Status {
        get { return Book.Status(rawValue: _status) ?? .unknown }
        set { _status = newValue.rawValue }
    }

    // MARK: - methods
}

// MARK: - IdentifiableType

extension Book: IdentifiableType {
    typealias Identity = String
    var identity: Identity { return "\(_sourceIdentifier)#\(url)" }
}
