//
//  BooksViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class BooksViewModel: NSObject {
    private let bag: DisposeBag = .init()
    let add: PublishSubject<Void> = .init()
    let groupIndex: BehaviorSubject<Int> = .init(value: 0)
    let books: BehaviorSubject<[Book]> = .init(value: [])

    init(persistence: BooksPersistenceProtocol) {
        super.init()
        groupIndex.filter { $0 == 0 }.flatMapLatest { _ in persistence.favoriteBook() }.bind(to: books).disposed(by: bag)
        groupIndex.filter { $0 == 1 }.flatMapLatest { _ in persistence.readBooks() }.bind(to: books).disposed(by: bag)
    }
}
