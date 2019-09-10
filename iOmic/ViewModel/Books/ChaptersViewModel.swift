//
//  ChaptersViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import WCDBSwift

class ChaptersViewModel: NSObject {
    private let bag: DisposeBag = .init()
    private let databaseManager: DatabaseManagerProtocol
    let load: PublishSubject<Void> = .init()
    let switchFavorited: PublishSubject<Void> = .init()
    let isFavorited: BehaviorSubject<Bool> = .init(value: false)
    let book: BehaviorSubject<Book>
    let chapters: BehaviorSubject<[Chapter]> = .init(value: [])

    init(book: Book, databaseManager: DatabaseManagerProtocol) {
        self.databaseManager = databaseManager
        self.book = .init(value: book)
        super.init()
        load.withLatestFrom(databaseManager.getBook(where: book.identity)).compactMap { $0?.isFavorited }.bind(to: isFavorited).disposed(by: bag)
        switchFavorited.withLatestFrom(isFavorited).withLatestFrom(self.book) { ($0, $1) }.subscribe(onNext: { isFavorited, value in
            var book = value
            book.isFavorited = isFavorited
            _ = databaseManager.saveBook(book)
        }).disposed(by: bag)
        let results = load.withLatestFrom(self.book)
            .flatMapLatest { book -> Observable<[Chapter]> in book.source.fetchChapters(book: book) }
            .share()
        results.bind(to: chapters).disposed(by: bag)
        results.compactMap { $0.first?.book }.bind(to: self.book).disposed(by: bag)
        load.on(.next(()))
    }
}
