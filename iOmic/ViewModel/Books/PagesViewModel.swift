//
//  PagesViewModel.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class PagesViewModel: NSObject {
    private let bag: DisposeBag = .init()
    let load: PublishSubject<Void> = .init()
    let chapter: BehaviorSubject<Chapter>
    let pages: BehaviorSubject<[Page]> = .init(value: [])

    init(chapter: Chapter) {
        self.chapter = .init(value: chapter)
        super.init()
        load.withLatestFrom(self.chapter).flatMapLatest { chapter in chapter.book.source.fetchPages(chapter: chapter) }.bind(to: pages).disposed(by: bag)
        load.on(.next(()))
    }
}
