//
//  Source.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FileKit
import Foundation
import Kingfisher
import RxDataSources
import RxSwift
import WCDBSwift

enum SourceIdentifier: String, ColumnCodable, IdentifiableType {
    case dongmanzhijia, manhuaren // JSON

    static let values: [SourceIdentifier] = [.dongmanzhijia, .manhuaren]

    var source: SourceProtocol {
        switch self {
        case .dongmanzhijia:
            return DongManZhiJia.shared
        case .manhuaren:
            return ManHuaRen.shared
        }
    }

    // MARK: - ColumnCodable

    static var columnType: ColumnType { return .text }
    func archivedValue() -> FundamentalValue { return FundamentalValue(rawValue) }
    init?(with value: FundamentalValue) { self.init(rawValue: value.stringValue) }

    // MARK: - IdentifiableType

    typealias Identity = RawValue
    var identity: Identity { return rawValue }
}

protocol SourceProtocol {
    var identifier: SourceIdentifier { get }
    var name: String { get }
    var available: Bool { get set }
    var filters: [FilterProrocol] { get }
    var modifier: AnyModifier { get }
    func fetchBooks(page: Int, query: String, filters: [FilterProrocol]) -> Single<[Book]>
    func fetchChapters(book: Book) -> Single<[Chapter]>
    func fetchPages(chapter: Chapter) -> Single<[Page]>
}

extension SourceProtocol {
    var available: Bool {
        set { KeyValues.shared.set(souce: self, available: newValue) }
        get { return KeyValues.shared.isAvailable(self) }
    }
}
