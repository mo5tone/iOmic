//
//  DatabaseManager.swift
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

class DatabaseManager {
    static let shared: DatabaseManager = .init()
    private var databaseName: String { return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOmic" }
    private(set) lazy var database: Database = { .init(withFileURL: (Path.userDocuments + "\(databaseName).db").url) }()

    // MARK: - instance methods

    func createTables() -> Completable {
        return Completable.merge(database.rx.create(table: Book.tableName, of: Book.self), database.rx.create(table: Chapter.tableName, of: Chapter.self), database.rx.create(table: Page.tableName, of: Page.self))
    }

    private init() {}
}
