//
//  DiscoveryPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class DiscoveryPresenter: DiscoveryPresenterProtocol {
    private(set) weak var view: DiscoveryViewProtocol?
    private(set) var interactor: DiscoveryInteractorProtocol
    private(set) var wireframe: DiscoveryWireframeProtocol

    init(view: DiscoveryViewProtocol?, interactor: DiscoveryInteractorProtocol, wireframe: DiscoveryWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - DiscoveryWireframeOutputProtocol

extension DiscoveryPresenter: DiscoveryWireframeOutputProtocol {}

// MARK: - DiscoveryViewOutputProtocol

extension DiscoveryPresenter: DiscoveryViewOutputProtocol {}

// MARK: - DiscoveryInteractorOutputProtocol

extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {}
