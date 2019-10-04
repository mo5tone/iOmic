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

    var differenceIdentifier: Chapter.DifferenceIdentifier { return "\(source.rawValue)#\(chapterUrl)#\(index)" }

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
        case source, chapterUrl = "chapter_url", index = "page_index", url, imageUrl = "image_url", path
        static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
            return [
                "multiPrimaryBinding": MultiPrimaryBinding(indexesBy: [source, chapterUrl, index], onConflict: .replace),
            ]
        }
    }

    // MARK: - Properties

    let source: Source
    let chapterUrl: String
    let index: Int
    var url: String?
    var imageUrl: String?
    var path: String?

    // MARK: - Init

    init(source: Source, chapter: Chapter, index: Int) {
        self.source = source
        chapterUrl = chapter.url
        self.index = index
    }
}
