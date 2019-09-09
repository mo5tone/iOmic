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
    private let bag: DisposeBag = .init()
    private let page: BehaviorSubject<Int> = .init(value: 0)
    let source: BehaviorSubject<SourceProtocol> = .init(value: SourceIdentifier.values[0].source)
    let title: BehaviorSubject<String> = .init(value: "Discovery")
    let load: PublishSubject<Void> = .init()
    let loadMore: PublishSubject<Void> = .init()
    let query: BehaviorSubject<String?> = .init(value: nil)
    let filters: BehaviorSubject<[FilterProrocol]> = .init(value: [])
    let books: BehaviorSubject<[Book]> = .init(value: [])
    var sharedSource: Observable<SourceProtocol> {
        return source.share(replay: 1, scope: .forever)
    }

    init(_ sourceProtocol: SourceProtocol? = nil) {
        super.init()
        if let sourceProtocol = sourceProtocol {
            source.on(.next(sourceProtocol))
        }
        source.map { _ in [] }.bind(to: books).disposed(by: bag)
        source.map { $0.name }.bind(to: title).disposed(by: bag)
        source.map { $0.filters }.bind(to: filters).disposed(by: bag)
        Observable.merge(source.map { _ in }, load).map { _ in 0 }.bind(to: page).disposed(by: bag)
        loadMore.withLatestFrom(page) { $1 + 1 }.bind(to: page).disposed(by: bag)
        Observable.merge(source.map { _ in }, load, loadMore)
            .withLatestFrom(Observable.combineLatest(source, page, query, filters, books))
            .flatMapLatest { (source, page, query, filters, books) -> Observable<[Book]> in
                source.fetchBooks(page: page, query: query ?? "", filters: filters)
                    .map {
                        if page == 0 { return $0 }
                        var array = Array(books)
                        array.append(contentsOf: $0)
                        return array
                    }

            }.catchErrorJustReturn([]).bind(to: books).disposed(by: bag)
    }

    func reset() {}
}
