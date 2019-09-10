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

protocol DatabaseManagerProtocol {
    var bookTable: Table<Book>? { get }
    var chapterTable: Table<Chapter>? { get }
    var pageTable: Table<Page>? { get }
    func getBook(where identity: Book.Identity) -> Observable<Book?>
    func saveBook(_ book: Book) -> Observable<Void>
}

class DatabaseManager {
    static let shared: DatabaseManager = .init()
    private var databaseName: String { return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOmic" }
    private lazy var database: Database = {
        let path = Path.userDocuments + "\(databaseName).db"
        return .init(withFileURL: path.url)
    }()

    var bookTable: Table<Book>? { return try? database.getTable(named: Book.tableName, of: Book.self) }
    var chapterTable: Table<Chapter>? { return try? database.getTable(named: Chapter.tableName, of: Chapter.self) }
    var pageTable: Table<Page>? { return try? database.getTable(named: Page.tableName, of: Page.self) }

    // MARK: - instance methods

    func createTables() throws {
        try database.create(table: Book.tableName, of: Book.self)
        try database.create(table: Chapter.tableName, of: Chapter.self)
        try database.create(table: Page.tableName, of: Page.self)
    }

    private init() {}
}

// MARK: - DatabaseManagerProtocol

extension DatabaseManager: DatabaseManagerProtocol {
    func getBook(where identity: Book.Identity) -> Observable<Book?> {
        guard let table = bookTable else { return Observable.empty() }
        return table.rx.getObject(on: Book.Properties.all, where: Book.Properties.identity == identity)
    }

    func saveBook(_ book: Book) -> Observable<Void> {
        guard let table = bookTable else { return Observable.empty() }
        return table.rx.insertOrReplace(objects: book)
    }
}
