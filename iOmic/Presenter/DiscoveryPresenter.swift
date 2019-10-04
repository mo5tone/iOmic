//
//  DiscoveryPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class DiscoveryPresenter: DiscoveryPresenterProtocol {
    // MARK: - Instance properties

    private(set) weak var view: DiscoveryViewProtocol?
    private(set) var interactor: DiscoveryInteractorProtocol
    private(set) var wireframe: DiscoveryWireframeProtocol
    private var source: Source = Source.values[0]
    private var page: Int = 0

    // MARK: - Init

    init(view: DiscoveryViewProtocol?, interactor: DiscoveryInteractorProtocol, wireframe: DiscoveryWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - DiscoveryWireframeOutputProtocol

extension DiscoveryPresenter: DiscoveryWireframeOutputProtocol {
    func didSelectSource(_ source: Source) {
        guard self.source != source else { return }
        self.source = source
        fetch()
    }
}

// MARK: - DiscoveryViewOutputProtocol

extension DiscoveryPresenter: DiscoveryViewOutputProtocol {
    func viewDidLoad() {
        fetch()
    }

    func showDetailSourcesView() {
        wireframe.showDetailSourcesView(current: source)
    }

    func fetch(where query: String = "", sortedBy fetchingSort: Source.FetchingSort = .popularity, refresh: Bool = true) {
        page = refresh ? 0 : page + 1
        interactor.fetch(in: source, page: page, query: query, sortedBy: fetchingSort)
    }

    func showChaptersView(book: Book) {
        wireframe.showChaptersView(book: book)
    }
}

// MARK: - DiscoveryInteractorOutputProtocol

extension DiscoveryPresenter: DiscoveryInteractorOutputProtocol {
    func didFetch(books: [Book]) {
        view?.reload(source: source, more: page > 0, books: books)
    }
}
