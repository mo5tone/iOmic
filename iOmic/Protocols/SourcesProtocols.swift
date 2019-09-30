//
//  SourcesProtocols.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol SourcesModuleDelegate: AnyObject {
    func didSelectSource(_ source: Source)
}

protocol SourcesWireframeProtocol: AnyObject {
    var presenter: SourcesWireframeOutputProtocol? { get }
    var delegate: SourcesModuleDelegate? { get }
    static func create(with source: Source, delegate: SourcesModuleDelegate?) -> UIViewController
    func dismiss(with source: Source)
}

protocol SourcesViewProtocol: AnyObject {
    var presenter: SourcesViewOutputProtocol! { get set }
    func update(sources: [Source], current source: Source)
}

protocol SourcesInteractorProtocol: AnyObject {
    var presenter: SourcesInteractorOutputProtocol? { get }
    var sources: [Source] { get }
    func set(souce: Source, available: Bool)
}

protocol SourcesWireframeOutputProtocol: AnyObject {}

protocol SourcesViewOutputProtocol: AnyObject {
    func viewDidLoad()
    func didTapDoneBarButtonItem()
    func didSelectRow(_ row: Int)
}

protocol SourcesInteractorOutputProtocol: AnyObject {}

protocol SourcesPresenterProtocol: AnyObject {
    var view: SourcesViewProtocol? { get }
    var interactor: SourcesInteractorProtocol { get }
    var wireframe: SourcesWireframeProtocol { get }
}
