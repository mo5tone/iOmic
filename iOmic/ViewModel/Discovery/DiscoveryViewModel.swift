//
//  DiscoveryViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class DiscoveryViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private var page = 0
    let source = PublishSubject<SourceProtocol>()
    let title = BehaviorSubject<String>(value: "Discovery")
    let load = PublishSubject<Void>()
    let loadMore = PublishSubject<Void>()
    let query = BehaviorSubject<String?>(value: nil)
    let filters = BehaviorSubject<[FilterProrocol]>(value: [])
    let books = BehaviorSubject<[Book]>(value: [])

    init(sourceProtocol: SourceProtocol) {
        super.init()
        source.map { $0.name }.bind(to: title).disposed(by: disposeBag)
        source.map { $0.defaultFilters }.bind(to: filters).disposed(by: disposeBag)
        Observable.merge(source.map { _ in }, load).subscribe { [weak self] in if case .next = $0 { self?.page = 0 } }.disposed(by: disposeBag)
        loadMore.subscribe { [weak self] in if case .next = $0 { self?.page += 1 } }.disposed(by: disposeBag)
        Observable.merge(source.map { _ in }, load, loadMore)
            .withLatestFrom(Observable.combineLatest(source, query, filters))
            .debug("load")
            .flatMapLatest { [weak self] (source, query, filters) -> Observable<[Book]> in
                guard let self = self else { throw Whoops.nilWeakSelf }
                if let online = source as? OnlineSourceProtocol {
                    return online.fetchBooks(page: self.page, query: query ?? "", filters: filters)
                } else {
                    throw Whoops.rawString("local source has not be implmented.")
                }
            }.bind(to: books).disposed(by: disposeBag)
        source.on(.next(sourceProtocol))
    }

    func reset() {}
}
