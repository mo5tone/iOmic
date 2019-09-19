//
//  ChaptersViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

protocol ChaptersViewModelDatabaseManager {
    func isFavorited(book: Book) -> Single<Bool>
    func setBook(_ book: Book, isFavorited: Bool) -> Completable
}

class ChaptersViewModel: ViewModel {
    let load: PublishSubject<Void> = .init()
    let switchFavorited: PublishSubject<Void> = .init()
    let isFavorited: BehaviorSubject<Bool> = .init(value: false)
    let book: BehaviorSubject<Book>
    let chapters: BehaviorSubject<[Chapter]> = .init(value: [])

    init(book: Book, databaseManager: ChaptersViewModelDatabaseManager) {
        self.book = .init(value: book)
        super.init()
        load.withLatestFrom(databaseManager.isFavorited(book: book))
            .bind(to: isFavorited)
            .disposed(by: bag)
        switchFavorited.withLatestFrom(Observable.combineLatest(isFavorited, self.book))
            .flatMapLatest { databaseManager.setBook($0.1, isFavorited: $0.0) }
            .subscribe()
            .disposed(by: bag)
        let results = load.withLatestFrom(self.book)
            .flatMapLatest { book -> Single<[Chapter]> in book.source.fetchChapters(book: book) }
            .catchError { [weak self] in self?.error.on(.next($0)); return .just([]) }
            .share()
        results.bind(to: chapters).disposed(by: bag)
        results.compactMap { $0.first?.book }.bind(to: self.book).disposed(by: bag)
        load.on(.next(()))
    }
}
