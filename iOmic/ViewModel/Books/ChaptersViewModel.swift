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

class ChaptersViewModel: NSObject {
    private let bag: DisposeBag = .init()
    let load: PublishSubject<Void> = .init()
    let isFavorited: BehaviorSubject<Bool> = .init(value: false)
    let book: BehaviorSubject<Book>
    let chapters: BehaviorSubject<[Chapter]> = .init(value: [])

    init(book: Book) {
        self.book = .init(value: book)
        super.init()
        let results = load.withLatestFrom(self.book)
            .flatMapLatest { book -> Observable<[Chapter]> in book.source.fetchChapters(book: book) }
            .share()
        results.bind(to: chapters).disposed(by: bag)
        results.compactMap { $0.first?.book }.bind(to: self.book).disposed(by: bag)
        self.book.map { $0.isFavorited }.bind(to: isFavorited).disposed(by: bag)
        load.on(.next(()))
    }
}
