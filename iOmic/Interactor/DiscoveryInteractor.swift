//
//  DiscoveryInteractor.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxSwift

class DiscoveryInteractor: DiscoveryInteractorProtocol {
    weak var presenter: DiscoveryInteractorOutputProtocol?
    private let bag: DisposeBag = .init()

    // MARK: - Public instance methods

    func fetchBooks(in source: SourceProtocol, where page: Int, query: String, sortedBy fetchingSort: Source.FetchingSort) {
        source.fetchBooks(where: page, query: query, sortedBy: fetchingSort)
            .catchErrorJustReturn([])
            .subscribe(onSuccess: { [weak self] in self?.presenter?.update(books: $0) })
            .disposed(by: bag)
    }
}
