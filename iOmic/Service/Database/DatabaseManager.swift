//
//  DatabaseManager.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/10.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FileKit
import Foundation
import WCDBSwift

extension TableCodableBase {
    static var tableName: String { return String(describing: self) }
}

class DatabaseManager {
    static let shared: DatabaseManager = .init()
    private var databaseName: String { return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOmic" }
    private lazy var database: Database = {
        let path = Path.userDocuments + "\(databaseName).db"
        return .init(withFileURL: path.url)
    }()

    // MARK: - instance methods

    func createTables() throws {
        try database.create(table: Book.tableName, of: Book.self)
        try database.create(table: Chapter.tableName, of: Chapter.self)
        try database.create(table: Page.tableName, of: Page.self)
    }

    private init() {}
}
