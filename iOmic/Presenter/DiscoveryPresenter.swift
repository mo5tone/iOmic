//
//  DiscoveryPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit

class DiscoveryPresenter: DiscoveryPresenterProtocol {
    // MARK: - Instance properties

    private(set) weak var view: DiscoveryViewProtocol?
    private(set) var interactor: DiscoveryInteractorProtocol
    private(set) var wireframe: DiscoveryWireframeProtocol
    private var source: Source = .dongmanzhijia

    // MARK: - Init

    init(view: DiscoveryViewProtocol?, interactor: DiscoveryInteractorProtocol, wireframe: DiscoveryWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - DiscoveryWireframeOutputProtocol

extension DiscoveryPresenter: DiscoveryWireframeOutputProtocol {
    func update(source: Source) {
        self.source = source
    }
}

// MARK: - DiscoveryViewOutputProtocol

extension DiscoveryPresenter: DiscoveryViewOutputProtocol {
    func viewDidLoad() {
        Logger.debug()
    }

    func didTapSourcesBarButtonItem() {
        wireframe.presentSourcesModule(current: source)
    }
}

// MARK: - DiscoveryInteractorOutputProtocol

extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {}
