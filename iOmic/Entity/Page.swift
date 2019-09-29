//
//  Page.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import Foundation
import WCDBSwift

struct Page: Differentiable, TableCodable, ColumnJSONCodable {
    // MARK: - Differentiable

    typealias DifferenceIdentifier = String

    var differenceIdentifier: Chapter.DifferenceIdentifier { return identity }

    func isContentEqual(to source: Page) -> Bool {
        return url == source.url
            && imageUrl == source.imageUrl
            && path == source.path
    }

    // MARK: - TableCodable

    enum CodingKeys: String, CodingTableKey {
        // swiftlint:disable:next nesting
        typealias Root = Page
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identity, chapter, index = "page_index", url, imageUrl = "image_url", path
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [identity: .init(isPrimary: true, isAutoIncrement: false, onConflict: .replace)]
        }
    }

    // MARK: - Properties

    let identity: String
    let chapter: Chapter
    var index: Int
    var url: String?
    var imageUrl: String?
    var path: String?

    // MARK: - Init

    init(chapter: Chapter, index: Int) {
        self.chapter = chapter
        self.index = index
        identity = "\(chapter.identity)#\(index)"
    }
}
