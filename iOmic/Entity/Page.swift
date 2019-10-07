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

    var differenceIdentifier: Chapter.DifferenceIdentifier { return "\(chapter.differenceIdentifier)#\(index)" }

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
        case source, chapter, index = "page_index", url, imageUrl = "image_url", path
        static var tableConstraintBindings: [TableConstraintBinding.Name: TableConstraintBinding]? {
            let chapterForeignKey: ForeignKey = .init(withForeignTable: Chapter.tableName, and: [Chapter.Properties.source, Chapter.Properties.url])
            return [
                "chapterForeignKey": ForeignKeyBinding([source, chapter], foreignKey: chapterForeignKey.onUpdate(.cascade).onDelete(.cascade)),
                "multiPrimary": MultiPrimaryBinding(indexesBy: [source, chapter, index], onConflict: .replace),
            ]
        }
    }

    // MARK: - Properties

    let source: Source
    let chapter: String
    let index: Int
    var url: String?
    var imageUrl: String?
    var path: String?

    // MARK: - Init

    init(chapter: Chapter, index: Int) {
        source = chapter.source
        self.chapter = chapter.url
        self.index = index
    }
}
