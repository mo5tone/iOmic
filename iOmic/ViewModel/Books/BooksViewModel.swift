//
//  BooksViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

protocol BooksViewModelDatabaseManager {
    var favorites: Single<[Book]> { get }
    var histories: Single<[Book]> { get }
}

class BooksViewModel: ViewModel {
    let add: PublishSubject<Void> = .init()
    let load: PublishSubject<Void> = .init()
    let segmentIndex: BehaviorSubject<Int> = .init(value: 0)
    let books: BehaviorSubject<[(SourceIdentifier, [Book])]> = .init(value: [])

    init(databaseManager: BooksViewModelDatabaseManager) {
        super.init()
        load.withLatestFrom(segmentIndex)
            .flatMapLatest { $0 == 0 ? databaseManager.favorites : databaseManager.histories }
            .map { books in SourceIdentifier.values.map { identifier in (identifier, books.filter { $0.sourceIdentifier == identifier }) }.filter { !$0.1.isEmpty } }
            .bind(to: books)
            .disposed(by: bag)
    }
}
