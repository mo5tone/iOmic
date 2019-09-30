//
//  FilesPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class FilesPresenter: FilesPresenterProtocol {
    private(set) weak var view: FilesViewProtocol?
    private(set) var interactor: FilesInteractorProtocol
    private(set) var wireframe: FilesWireframeProtocol

    init(view: FilesViewProtocol?, interactor: FilesInteractorProtocol, wireframe: FilesWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - FilesWireframeOutputProtocol

extension FilesPresenter: FilesWireframeOutputProtocol {}

// MARK: - FilesViewOutputProtocol

extension FilesPresenter: FilesViewOutputProtocol {}

// MARK: - FilesInteractorOutputProtocol

extension FilesPresenter: FilesInteractorOutputProtocol {}
