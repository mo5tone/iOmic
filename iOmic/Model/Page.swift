//
//  Page.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxDataSources
import WCDBSwift

struct Page: IdentifiableType, Equatable, TableCodable, ColumnJSONCodable {
    // MARK: - IdentifiableType

    typealias Identity = String
    let identity: Identity

    // MARK: - Equatable

    static func == (lhs: Page, rhs: Page) -> Bool {
        return lhs.chapter.identity == rhs.chapter.identity
            && lhs.index == rhs.index
            && lhs.url == rhs.url
            && lhs.imageUrl == rhs.imageUrl
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        typealias Root = Page
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, chapter, index, url, imageUrl = "image_url"
        static var columConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - props.

    let chapter: Chapter
    var index: Int
    var url: String?
    var imageUrl: String?

    // MARK: - public

    init(chapter: Chapter, index: Int) {
        self.chapter = chapter
        self.index = index
        identity = "\(chapter.identity)#\(index)"
    }
}
