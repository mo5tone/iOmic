//
//  SourcesPresenter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class SourcesPresenter: SourcesPresenterProtocol {
    private(set) weak var view: SourcesViewProtocol?
    private(set) var interactor: SourcesInteractorProtocol
    private(set) var wireframe: SourcesWireframeProtocol

    init(view: SourcesViewProtocol?, interactor: SourcesInteractorProtocol, wireframe: SourcesWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - SourcesWireframeOutputProtocol

extension SourcesPresenter: SourcesWireframeOutputProtocol {}

// MARK: - SourcesViewOutputProtocol

extension SourcesPresenter: SourcesViewOutputProtocol {}

// MARK: - SourcesInteractorOutputProtocol

extension SourcesPresenter: SourcesInteractorOutputProtocol {}
