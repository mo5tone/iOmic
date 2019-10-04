//
//  ChaptersInteractor.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//
import RxSwift
import WCDBSwift

protocol ChaptersDatabaseManager: AnyObject {
    func isFavorite(book: Book) -> Single<Bool>
    func set(book: Book, isFavorite: Bool) -> Completable
}

extension DatabaseManager: ChaptersDatabaseManager {
    func isFavorite(book: Book) -> Single<Bool> {
        guard let table = bookTable else { return .error(Whoops.nilProperty("bookTable")) }
        let condition = Book.Properties.source == book.source.rawValue && Book.Properties.url == book.url
        return table.rx.getValue(on: Book.Properties.isFavorite, where: condition)
            .catchErrorJustReturn(.init(nil))
            .map { $0.type == .null ? false : ($0.int32Value != 0) }
    }

    func set(book: Book, isFavorite: Bool) -> Completable {
        guard let table = bookTable else { return .error(Whoops.nilProperty("bookTable")) }
        let condition = Book.Properties.source == book.source.rawValue && Book.Properties.url == book.url
        var target = book
        target.isFavorite = isFavorite
        return table.rx.getObject(on: Book.Properties.all, where: condition)
            .flatMapCompletable { $0 == nil
                ? table.rx.insertOrReplace(objects: target)
                : table.rx.update(on: [Book.Properties.isFavorite], with: [isFavorite], where: condition)
            }
    }
}

class ChaptersInteractor: ChaptersInteractorProtocol {
    weak var presenter: ChaptersInteractorOutputProtocol?
    private let bag: DisposeBag = .init()
    private let source: SourceProtocol
    private let databaseManager: ChaptersDatabaseManager

    init(source: SourceProtocol, databaseManager: ChaptersDatabaseManager) {
        self.source = source
        self.databaseManager = databaseManager
    }

    func fetch(where book: Book) {
        databaseManager.isFavorite(book: book)
            .flatMap { [weak self] isFavorite -> Single<(Book, [Chapter])> in
                guard let self = self else { throw Whoops.nilWeakSelf }
                return self.source.fetchBookAndChapters(where: book)
                    .map {
                        var variable = $0.0
                        variable.isFavorite = isFavorite
                        return (variable, $0.1)
                    }
            }
            .catchErrorJustReturn((book, []))
            .subscribe(onSuccess: { [weak self] in self?.presenter?.didFetch(book: $0.0, chapters: $0.1) })
            .disposed(by: bag)
    }

    func set(book: Book, isFavorite: Bool) {
        databaseManager.set(book: book, isFavorite: isFavorite)
            .subscribe(onCompleted: { [weak self] in self?.presenter?.didSetFavorite(isFavorite) })
            .disposed(by: bag)
    }
}
