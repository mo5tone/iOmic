//
//  TabBarProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol TabBarWireframeProtocol: AnyObject {
    static func create() -> UIViewController
}

protocol TabBarViewProtocol: AnyObject {
    var presenter: TabBarViewOutputProtocol! { get set }
}

protocol TabBarInteractorProtocol: AnyObject {
    var presenter: TabBarInteractorOutputProtocol? { get }
}

protocol TabBarViewOutputProtocol: AnyObject {}

protocol TabBarInteractorOutputProtocol: AnyObject {}

protocol TabBarPresenterProtocol: AnyObject {
    var view: TabBarViewProtocol? { get }
    var interactor: TabBarInteractorProtocol { get }
    var wireframe: TabBarWireframeProtocol { get }
}
