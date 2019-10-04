//
//  SourcesPresenter.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class SourcesPresenter: SourcesPresenterProtocol {
    // MARK: - Instance properties

    private(set) weak var view: SourcesViewProtocol?
    private(set) var interactor: SourcesInteractorProtocol
    private(set) var wireframe: SourcesWireframeProtocol
    private var source: Source

    // MARK: - Init

    init(view: SourcesViewProtocol?, interactor: SourcesInteractorProtocol, wireframe: SourcesWireframeProtocol, source: Source) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        self.source = source
    }
}

// MARK: - SourcesWireframeOutputProtocol

extension SourcesPresenter: SourcesWireframeOutputProtocol {}

// MARK: - SourcesViewOutputProtocol

extension SourcesPresenter: SourcesViewOutputProtocol {
    func viewDidLoad() {
        view?.reload(sources: interactor.sources, current: source)
    }

    func didTapDoneBarButtonItem() {
        wireframe.dismiss(with: source)
    }

    func didSelectRow(_ row: Int) {
        source = interactor.sources[row]
        wireframe.dismiss(with: source)
    }
}

// MARK: - SourcesInteractorOutputProtocol

extension SourcesPresenter: SourcesInteractorOutputProtocol {}
