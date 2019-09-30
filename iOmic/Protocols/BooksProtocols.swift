//
//  BooksProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol BooksWireframeProtocol: AnyObject {
    var presenter: BooksWireframeOutputProtocol? { get }
    static func create() -> UIViewController
}

protocol BooksViewProtocol: AnyObject {
    var presenter: BooksViewOutputProtocol! { get set }
}

protocol BooksInteractorProtocol: AnyObject {
    var presenter: BooksInteractorOutputProtocol? { get }
}

protocol BooksWireframeOutputProtocol: AnyObject {}

protocol BooksViewOutputProtocol: AnyObject {}

protocol BooksInteractorOutputProtocol: AnyObject {}

protocol BooksPresenterProtocol: AnyObject {
    var view: BooksViewProtocol? { get }
    var interactor: BooksInteractorProtocol { get }
    var wireframe: BooksWireframeProtocol { get }
}
