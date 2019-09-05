//
//  BookViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class BookViewModel: NSObject {
    private let bag: DisposeBag = .init()
    let load: PublishSubject<Void> = .init()
    let toggleFavorite: PublishSubject<Void> = .init()
    let isFavorited: Bool = false
    let book: BehaviorSubject<Book>
    let chapters: BehaviorSubject<[Chapter]> = .init(value: [])

    init(book: Book) {
        self.book = .init(value: book)
        super.init()
        let results = load.withLatestFrom(self.book)
            .flatMapLatest { book -> Observable<[Chapter]> in book.source.fetchChapters(book: book) }
            .share()
        results.debug("chapters").bind(to: chapters).disposed(by: bag)
        results.compactMap { $0.first?.book }.debug("book").bind(to: self.book).disposed(by: bag)
        load.on(.next(()))
    }
}