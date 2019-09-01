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
    private let page = BehaviorSubject<Int>(value: 0)
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
        Observable.merge(source.map { _ in }, load).map { _ in 0 }.bind(to: page).disposed(by: disposeBag)
        loadMore.withLatestFrom(page, resultSelector: { $1 + 1 }).bind(to: page).disposed(by: disposeBag)
        Observable.merge(source.map { _ in }, load, loadMore)
            .withLatestFrom(Observable.combineLatest(source, page, query, filters, books))
            .debug("load")
            .flatMapLatest { (source, page, query, filters, books) -> Observable<[Book]> in
                if let online = source as? OnlineSourceProtocol {
                    return online.fetchBooks(page: page, query: query ?? "", filters: filters).catchErrorJustReturn([]).map {
                        if page == 0 { return $0 }
                        var array = Array(books)
                        array.append(contentsOf: $0)
                        return array
                    }
                } else {
                    throw Whoops.rawString("local source has not be implmented.")
                }
            }.bind(to: books).disposed(by: disposeBag)
        source.on(.next(sourceProtocol))
    }

    func reset() {}
}
