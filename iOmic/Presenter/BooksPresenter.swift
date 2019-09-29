//
//  BooksPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class BooksPresenter: BooksPresenterProtocol {
    private(set) weak var view: BooksViewProtocol?
    private(set) var interactor: BooksInteractorProtocol
    private(set) var wireframe: BooksWireframeProtocol

    init(view: BooksViewProtocol?, interactor: BooksInteractorProtocol, wireframe: BooksWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - BooksViewOutputProtocol

extension BooksPresenter: BooksViewOutputProtocol {}

// MARK: - BooksInteractorOutputProtocol

extension BooksPresenter: BooksInteractorOutputProtocol {}
