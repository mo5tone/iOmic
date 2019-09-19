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
    var database: Database { get }
    var bookTable: Table<Book>? { get }
    var chapterTable: Table<Chapter>? { get }
    var pageTable: Table<Page>? { get }
}

class DatabaseManager: DatabaseManagerProtocol {
    static let shared: DatabaseManager = .init()
    private var databaseName: String { return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "iOmic" }
    private(set) lazy var database: Database = { .init(withFileURL: (Path.userDocuments + "\(databaseName).db").url) }()
    var bookTable: Table<Book>? { return try? database.getTable(named: Book.tableName, of: Book.self) }
    var chapterTable: Table<Chapter>? { return try? database.getTable(named: Chapter.tableName, of: Chapter.self) }
    var pageTable: Table<Page>? { return try? database.getTable(named: Page.tableName, of: Page.self) }

    // MARK: - instance methods

    func createTables() -> Completable {
        return Completable.zip(database.rx.create(table: Book.tableName, of: Book.self), database.rx.create(table: Chapter.tableName, of: Chapter.self), database.rx.create(table: Page.tableName, of: Page.self))
    }

    private init() {}
}

// MARK: - BooksViewModelDatabaseManager

extension DatabaseManager: BooksViewModelDatabaseManager {
    var favorites: Single<[Book]> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.isFavorited == true)
    }

    var histories: Single<[Book]> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.readAt.isNotNull(), orderBy: [Book.Properties.readAt.asOrder(by: .descending)])
    }
}

// MARK: - ChaptersViewModelDatabaseManager

extension DatabaseManager: ChaptersViewModelDatabaseManager {
    func isFavorited(book: Book) -> Single<Bool> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getValue(on: Book.Properties.isFavorited, where: Book.Properties.identity == book.identity)
            .catchErrorJustReturn(.init(0))
            .map { $0.int32Value == 1 }
    }

    func setBook(_ book: Book, isFavorited: Bool) -> Completable {
        guard let table = bookTable else { return Completable.error(Whoops.nilProperty("bookTable")) }
        let newBook: Book = {
            var book = $0
            book.isFavorited = isFavorited
            return book
        }(book)
        return table.rx.getObject(on: Book.Properties.all, where: Book.Properties.identity == book.identity)
            .catchErrorJustReturn(nil)
            .flatMapCompletable {
                $0 == nil
                    ? table.rx.insertOrReplace(objects: newBook)
                    : table.rx.update(on: Book.Properties.isFavorited, with: newBook, where: Book.Properties.identity == book.identity)
            }
    }
}

// MARK: - PagesViewModelDatabaseManager

extension DatabaseManager: PagesViewModelDatabaseManager {
    func setBook(_ book: Book, readAt: Date?) -> Completable {
        guard let table = bookTable else { return Completable.error(Whoops.nilProperty("bookTable")) }
        let newBook: Book = {
            var book = $0
            book.readAt = readAt
            return book
        }(book)
        return table.rx.getObject(on: Book.Properties.all, where: Book.Properties.identity == book.identity)
            .catchErrorJustReturn(nil)
            .flatMapCompletable {
                $0 == nil
                    ? table.rx.insertOrReplace(objects: newBook)
                    : table.rx.update(on: Book.Properties.readAt, with: newBook, where: Book.Properties.identity == book.identity)
            }
    }
}
