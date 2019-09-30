//
//  DiscoveryProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol DiscoveryWireframeProtocol: AnyObject {
    var presenter: DiscoveryWireframeOutputProtocol? { get }
    static func create() -> UIViewController
}

protocol DiscoveryViewProtocol: AnyObject {
    var presenter: DiscoveryViewOutputProtocol! { get set }
}

protocol DiscoveryInteractorProtocol: AnyObject {
    var presenter: DiscoveryInteractorOutputProtocol? { get }
}

protocol DiscoveryWireframeOutputProtocol: AnyObject {}

protocol DiscoveryViewOutputProtocol: AnyObject {}

protocol DiscoveryInteractorOutputProtocol: AnyObject {}

protocol DiscoveryPresenterProtocol: AnyObject {
    var view: DiscoveryViewProtocol? { get }
    var interactor: DiscoveryInteractorProtocol { get }
    var wireframe: DiscoveryWireframeProtocol { get }
}
