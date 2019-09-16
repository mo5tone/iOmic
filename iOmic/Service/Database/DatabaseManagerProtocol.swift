//
//  DatabaseManagerProtocol.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/11.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

protocol DatabaseManagerProtocol {
    var bookTable: Table<Book>? { get }
    var chapterTable: Table<Chapter>? { get }
    var pageTable: Table<Page>? { get }
}

protocol BooksDatabaseManagerProtocol: DatabaseManagerProtocol {
    func favoriteBooks() -> Single<[Book]>
    func readBooks() -> Single<[Book]>
}

protocol ChaptersDatabaseManagerProtocol: DatabaseManagerProtocol {
    func getBook(where identity: Book.Identity) -> Single<Book?>
    func update(isFavorited: Bool, on book: Book) -> Completable
}

protocol PagesDatabaseManagerProtocol: DatabaseManagerProtocol {
    func update(readAt: Date?, on book: Book) -> Completable
}

// MARK: - DatabaseManagerProtocol

extension DatabaseManager: DatabaseManagerProtocol {
    var bookTable: Table<Book>? { return try? database.getTable(named: Book.tableName, of: Book.self) }
    var chapterTable: Table<Chapter>? { return try? database.getTable(named: Chapter.tableName, of: Chapter.self) }
    var pageTable: Table<Page>? { return try? database.getTable(named: Page.tableName, of: Page.self) }
}

// MARK: - BooksDatabaseManagerProtocol

extension DatabaseManager: BooksDatabaseManagerProtocol {
    func favoriteBooks() -> Single<[Book]> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.isFavorited == true)
    }

    func readBooks() -> Single<[Book]> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.readAt.isNotNull(), orderBy: [Book.Properties.readAt.asOrder(by: .descending)])
    }
}

// MARK: - ChaptersDatabaseManagerProtocol

extension DatabaseManager: ChaptersDatabaseManagerProtocol {
    func getBook(where identity: Book.Identity) -> Single<Book?> {
        guard let table = bookTable else { return Single.error(Whoops.nilProperty("bookTable")) }
        return table.rx.getObject(on: Book.Properties.all, where: Book.Properties.identity == identity)
    }

    func update(isFavorited: Bool, on book: Book) -> Completable {
        guard let table = bookTable else { return Completable.empty() }
        var copy = book
        copy.isFavorited = isFavorited
        return table.rx.insertOrReplace(objects: copy)
    }
}

// MARK: - PagesDatabaseManagerProtocol

extension DatabaseManager: PagesDatabaseManagerProtocol {
    func update(readAt: Date?, on book: Book) -> Completable {
        guard let table = bookTable else { return Completable.empty() }
        var copy = book
        copy.readAt = readAt
        return table.rx.insertOrReplace(objects: copy)
    }
}
