//
//  Source.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DefaultsKit
import FileKit
import Foundation
import Kingfisher
import RxSwift

enum SourceIdentifier: String {
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
}

protocol SourceProtocol {
    var identifier: SourceIdentifier { get }
    var name: String { get }
    var available: Bool { get set }
    var filters: [FilterProrocol] { get }
    var modifier: AnyModifier { get }
    func fetchBooks(page: Int, query: String, filters: [FilterProrocol]) -> Observable<[Book]>
    func fetchChapters(book: Book) -> Observable<[Chapter]>
    func fetchPages(chapter: Chapter) -> Observable<[Page]>
}

extension SourceProtocol {
    var available: Bool {
        set {
            var sourceAvailability = Defaults.shared.get(for: .sourceAvailability) ?? [:]
            sourceAvailability[identifier.rawValue] = newValue
            Defaults.shared.set(sourceAvailability, for: .sourceAvailability)
        }
        get {
            let sourceAvailability = Defaults.shared.get(for: .sourceAvailability) ?? [:]
            return sourceAvailability[identifier.rawValue] ?? true
        }
    }
}
