//
//  PagesViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class PagesViewModel: ViewModel {
    let load: PublishSubject<Void> = .init()
    let chapter: BehaviorSubject<Chapter>
    let pages: BehaviorSubject<[Page]> = .init(value: [])
    private let databaseManager: PagesDatabaseManagerProtocol

    init(chapter: Chapter, databaseManager: PagesDatabaseManagerProtocol) {
        self.chapter = .init(value: chapter)
        self.databaseManager = databaseManager
        super.init()
        self.databaseManager.update(readAt: .init(), on: chapter.book).subscribe().disposed(by: bag)
        load.withLatestFrom(self.chapter)
            .flatMapLatest { chapter in chapter.book.source.fetchPages(chapter: chapter) }
            .catchError { [weak self] in self?.error.on(.next($0)); return .just([]) }
            .bind(to: pages)
            .disposed(by: bag)
        load.on(.next(()))
    }
}
