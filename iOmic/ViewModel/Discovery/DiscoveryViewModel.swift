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
    struct Element {
        let title: String
        let subTitle: String
        let coverImageData: Data?
    }

    private let disposeBag = DisposeBag()
    private var page = 0
    let source = PublishSubject<SourceProtocol>()
    let title = BehaviorSubject<String>(value: "Discovery")
    let reload = PublishSubject<Void>()
    let loadMore = PublishSubject<Void>()
    let query = BehaviorSubject<String?>(value: nil)
    let filters = BehaviorSubject<[FilterProrocol]>(value: [])
    let elements = BehaviorSubject<[Element]>(value: [])

    init(source: SourceProtocol) {
        super.init()
        self.source.subscribe { [weak self] in
            guard case let .next(value) = $0 else { return }
            self?.title.on(.next(value.name))
            self?.filters.on(.next(value.defaultFilters))
        }.disposed(by: disposeBag)
        Observable.merge(self.source.map { _ in }, reload).subscribe { [weak self] in if case .next = $0 { self?.page = 0 } }.disposed(by: disposeBag)
        loadMore.subscribe { [weak self] in if case .next = $0 { self?.page += 1 } }.disposed(by: disposeBag)
        Observable.merge(self.source.map { _ in }, reload, loadMore).subscribe { if case .next = $0 { /* load data*/ } }.disposed(by: disposeBag)
        self.source.on(.next(source))
    }
}
