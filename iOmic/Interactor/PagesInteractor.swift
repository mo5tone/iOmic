//
//  PagesInteractor.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxSwift

class PagesInteractor: PagesInteractorProtocol {
    // MARK: - Instance properties

    weak var presenter: PagesInteractorOutputProtocol?
    private let bag: DisposeBag = .init()

    // MARK: - Public instance methods

    func fetch(where chapter: Chapter) {
        let source = chapter.source
        source.fetchPages(where: chapter)
            .catchErrorJustReturn([])
            .subscribe(onSuccess: { [weak self] in self?.presenter?.didFetch(chapter: chapter, pages: $0) })
            .disposed(by: bag)
    }
}
