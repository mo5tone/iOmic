//
//  ChaptersPresenter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class ChaptersPresenter: ChaptersPresenterProtocol {
    private(set) weak var view: ChaptersViewProtocol?
    private(set) var interactor: ChaptersInteractorProtocol
    private(set) var wireframe: ChaptersWireframeProtocol
    private var book: Book

    init(view: ChaptersViewProtocol?, interactor: ChaptersInteractorProtocol, wireframe: ChaptersWireframeProtocol, book: Book) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.book = book
    }
}

// MARK: - ChaptersWireframeOutputProtocol

extension ChaptersPresenter: ChaptersWireframeOutputProtocol {}

// MARK: - ChaptersViewOutputProtocol

extension ChaptersPresenter: ChaptersViewOutputProtocol {
    func viewDidLoad() {
        interactor.fetch(where: book)
    }

    func fetch() {
        interactor.fetch(where: book)
    }

    func showPagesView(where chapter: Chapter) {
        wireframe.showPagesView(where: chapter)
    }

    func setFavorite() {
        interactor.set(book: book, isFavorite: !book.isFavorite)
    }
}

// MARK: - ChaptersInteractorOutputProtocol

extension ChaptersPresenter: ChaptersInteractorOutputProtocol {
    func didFetch(book: Book, chapters: [Chapter]) {
        self.book = book
        view?.reload(book: book)
        view?.reload(chapters: chapters)
    }

    func didSetFavorite(_ isFavorite: Bool) {
        book.isFavorite = isFavorite
        view?.reload(book: book)
    }
}
