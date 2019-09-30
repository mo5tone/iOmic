//
//  SourcesProtocols.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol SourcesWireframeProtocol: AnyObject {
    var presenter: SourcesWireframeOutputProtocol? { get }
    static func create() -> UIViewController
}

protocol SourcesViewProtocol: AnyObject {
    var presenter: SourcesViewOutputProtocol! { get set }
}

protocol SourcesInteractorProtocol: AnyObject {
    var presenter: SourcesInteractorOutputProtocol? { get }
}

protocol SourcesWireframeOutputProtocol: AnyObject {}

protocol SourcesViewOutputProtocol: AnyObject {}

protocol SourcesInteractorOutputProtocol: AnyObject {}

protocol SourcesPresenterProtocol: AnyObject {
    var view: SourcesViewProtocol? { get }
    var interactor: SourcesInteractorProtocol { get }
    var wireframe: SourcesWireframeProtocol { get }
}
