//
//  PagesViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

protocol PagesViewModelDatabaseManager {
    func setBook(_ book: Book, readAt: Date?) -> Completable
}

class PagesViewModel: ViewModel {
    let load: PublishSubject<Void> = .init()
    let chapter: BehaviorSubject<Chapter>
    let pages: BehaviorSubject<[Page]> = .init(value: [])

    init(chapter: Chapter, databaseManager: PagesViewModelDatabaseManager) {
        self.chapter = .init(value: chapter)
        super.init()
        load.flatMapFirst { databaseManager.setBook(chapter.book, readAt: .init()) }.retry().subscribe().disposed(by: bag)
        load.withLatestFrom(self.chapter)
            .flatMapLatest { chapter in chapter.book.source.fetchPages(chapter: chapter) }
            .catchError { [weak self] in self?.error.on(.next($0)); return .just([]) }
            .bind(to: pages)
            .disposed(by: bag)
        load.on(.next(()))
    }
}
