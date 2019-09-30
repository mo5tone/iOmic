//
//  SettingsPresenter.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class SettingsPresenter: SettingsPresenterProtocol {
    private(set) weak var view: SettingsViewProtocol?
    private(set) var interactor: SettingsInteractorProtocol
    private(set) var wireframe: SettingsWireframeProtocol

    init(view: SettingsViewProtocol?, interactor: SettingsInteractorProtocol, wireframe: SettingsWireframeProtocol) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - SettingsWireframeOutputProtocol

extension SettingsPresenter: SettingsWireframeOutputProtocol {}

// MARK: - SettingsViewOutputProtocol

extension SettingsPresenter: SettingsViewOutputProtocol {}

// MARK: - SettingsInteractorOutputProtocol

extension SettingsPresenter: SettingsInteractorOutputProtocol {}
