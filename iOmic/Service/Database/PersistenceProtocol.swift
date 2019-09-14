//
//  PersistenceProtocol.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/11.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

protocol PersistenceProtocol {
    var bookTable: Table<Book>? { get }
    var chapterTable: Table<Chapter>? { get }
    var pageTable: Table<Page>? { get }
}

protocol BooksPersistenceProtocol: PersistenceProtocol {
    func favoriteBooks() -> Observable<[Book]>
    func readBooks() -> Observable<[Book]>
}

protocol ChaptersPersistenceProtocol: PersistenceProtocol {
    func getBook(where identity: Book.Identity) -> Observable<Book?>
    func update(isFavorited: Bool, on book: Book) -> Observable<Void>
}

protocol PagesPersistenceProtocol: PersistenceProtocol {
    func update(readAt: Date?, on book: Book) -> Observable<Void>
}

// MARK: - PersistenceProtocol

extension Persistence: PersistenceProtocol {
    var bookTable: Table<Book>? { return try? database.getTable(named: Book.tableName, of: Book.self) }
    var chapterTable: Table<Chapter>? { return try? database.getTable(named: Chapter.tableName, of: Chapter.self) }
    var pageTable: Table<Page>? { return try? database.getTable(named: Page.tableName, of: Page.self) }
}

// MARK: - BooksPersistenceProtocol

extension Persistence: BooksPersistenceProtocol {
    func favoriteBooks() -> Observable<[Book]> {
        guard let table = bookTable else { return Observable.empty() }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.isFavorited == true)
    }

    func readBooks() -> Observable<[Book]> {
        guard let table = bookTable else { return Observable.empty() }
        return table.rx.getObjects(on: Book.Properties.all, where: Book.Properties.readAt.isNotNull(), orderBy: [Book.Properties.readAt.asOrder(by: .descending)])
    }
}

// MARK: - ChaptersPersistenceProtocol

extension Persistence: ChaptersPersistenceProtocol {
    func getBook(where identity: Book.Identity) -> Observable<Book?> {
        guard let table = bookTable else { return Observable.empty() }
        return table.rx.getObject(on: Book.Properties.all, where: Book.Properties.identity == identity)
    }

    func update(isFavorited: Bool, on book: Book) -> Observable<Void> {
        guard let table = bookTable else { return Observable.empty() }
        var copy = book
        copy.isFavorited = isFavorited
        return table.rx.insertOrReplace(objects: copy)
    }
}

extension Persistence: PagesPersistenceProtocol {
    func update(readAt: Date?, on book: Book) -> Observable<Void> {
        guard let table = bookTable else { return Observable.empty() }
        var copy = book
        copy.readAt = readAt
        return table.rx.insertOrReplace(objects: copy)
    }
}
