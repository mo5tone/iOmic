//
//  Persistence.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/10.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FileKit
import Foundation
import RxSwift
import WCDBSwift

extension TableCodableBase {
    static var tableName: String { return String(describing: self) }
}

class Persistence {
    static let shared: Persistence = .init()
    private var databaseName: String { return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOmic" }
    private(set) lazy var database: Database = { .init(withFileURL: (Path.userDocuments + "\(databaseName).db").url) }()

    // MARK: - instance methods

    func createTables() -> Observable<Void> {
        return Observable.merge(database.rx.create(table: Book.tableName, of: Book.self), database.rx.create(table: Chapter.tableName, of: Chapter.self), database.rx.create(table: Page.tableName, of: Page.self)).take(3)
    }

    private init() {}
}
