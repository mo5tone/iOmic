//
//  TabBarPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class TabBarPresenter: TabBarPresenterProtocol {
    private(set) weak var view: TabBarViewProtocol?
    private(set) var interactor: TabBarInteractorProtocol
    private(set) var wireframe: TabBarWireframeProtocol

    init(view: TabBarViewProtocol?, interactor: TabBarInteractorProtocol, wireframe: TabBarWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - TabBarViewOutputProtocol

extension TabBarPresenter: TabBarViewOutputProtocol {}

// MARK: - TabBarInteractorOutputProtocol

extension TabBarPresenter: TabBarInteractorOutputProtocol {}
