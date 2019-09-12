//
//  BooksViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class BooksViewModel: ViewModel {
    let add: PublishSubject<Void> = .init()
    let groupIndex: BehaviorSubject<Int> = .init(value: 0)
    let books: BehaviorSubject<[(SourceIdentifier, [Book])]> = .init(value: [])

    init(persistence: BooksPersistenceProtocol) {
        super.init()
        groupIndex.throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .flatMapLatest { $0 == 0 ? persistence.favoriteBook() : persistence.readBooks() }
            .map { books in SourceIdentifier.values.map { identifier in (identifier, books.filter { $0.sourceIdentifier == identifier }) }.filter { !$0.1.isEmpty } }
            .bind(to: books)
            .disposed(by: bag)
    }
}
