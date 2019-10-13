//
//  PagesPresenter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/9.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class PagesPresenter: PagesPresenterProtocol {
    private(set) weak var view: PagesViewProtocol?
    private(set) var interactor: PagesInteractorProtocol
    private(set) var wireframe: PagesWireframeProtocol
    var chapter: Chapter!

    init(view: PagesViewProtocol?, interactor: PagesInteractorProtocol, wireframe: PagesWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - PagesWireframeOutputProtocol

extension PagesPresenter: PagesWireframeOutputProtocol {}

// MARK: - PagesViewOutputProtocol

extension PagesPresenter: PagesViewOutputProtocol {
    func viewDidLoad() {
        fetch()
    }

    func fetch() {
        interactor.fetch(where: chapter)
    }
}

// MARK: - PagesInteractorOutputProtocol

extension PagesPresenter: PagesInteractorOutputProtocol {
    func didFetch(chapter: Chapter, pages: [Page]) {
        self.chapter = chapter
        view?.reload(chapter: chapter, pages: pages)
    }
}
