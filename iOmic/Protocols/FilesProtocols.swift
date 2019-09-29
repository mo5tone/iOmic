//
//  FilesProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol FilesWireframeProtocol: AnyObject {
    static func create() -> UIViewController
}

protocol FilesViewProtocol: AnyObject {
    var presenter: FilesViewOutputProtocol! { get set }
}

protocol FilesInteractorProtocol: AnyObject {
    var presenter: FilesInteractorOutputProtocol? { get }
}

protocol FilesViewOutputProtocol: AnyObject {}

protocol FilesInteractorOutputProtocol: AnyObject {}

protocol FilesPresenterProtocol: AnyObject {
    var view: FilesViewProtocol? { get }
    var interactor: FilesInteractorProtocol { get }
    var wireframe: FilesWireframeProtocol { get }
}
