//
//  SettingsProtocols.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

protocol SettingsWireframeProtocol: AnyObject {
    var presenter: SettingsWireframeOutputProtocol? { get }
    static func create() -> UIViewController
}

protocol SettingsViewProtocol: AnyObject {
    var presenter: SettingsViewOutputProtocol! { get set }
}

protocol SettingsInteractorProtocol: AnyObject {
    var presenter: SettingsInteractorOutputProtocol? { get }
}

protocol SettingsWireframeOutputProtocol: AnyObject {}

protocol SettingsViewOutputProtocol: AnyObject {}

protocol SettingsInteractorOutputProtocol: AnyObject {}

protocol SettingsPresenterProtocol: AnyObject {
    var view: SettingsViewProtocol? { get }
    var interactor: SettingsInteractorProtocol { get }
    var wireframe: SettingsWireframeProtocol { get }
}
