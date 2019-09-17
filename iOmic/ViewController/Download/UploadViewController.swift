//
//  UploadViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/16.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DeviceKit
import RxCocoa
import RxSwift
import UIKit

protocol UploadViewCoordinator: PresentedViewCoordinator {
    func dismiss()
}

class UploadViewController: UIViewController {
    private weak var coordinator: UploadViewCoordinator?
    private let viewModel: UploadViewModel
    private let bag: DisposeBag = .init()
    private lazy var doneButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .done, target: nil, action: nil)
    private lazy var toggleButtonItem: UIBarButtonItem = .init(title: "Start", style: .plain, target: nil, action: nil)
    @IBOutlet var portLabel: UILabel!
    @IBOutlet var portTextField: UITextField!
    @IBOutlet var authenticationLabel: UILabel!
    @IBOutlet var authenticationSwitch: UISwitch!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var tableView: UITableView!

    init(coordinator: UploadViewCoordinator?, viewModel: UploadViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { print(String(describing: self)) }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isToolbarHidden = true
    }

    private func setupView() {
        view.backgroundColor = UIColor.flat.background

        navigationItem.rightBarButtonItem = doneButtonItem
        navigationItem.title = "Upload"

        portLabel.text = "Port:"
        portTextField.placeholder = "Port"
        portTextField.textContentType = .creditCardNumber
        portTextField.keyboardType = .numberPad
        authenticationLabel.text = "Authentication"
        authenticationSwitch.isOn = false
        usernameLabel.text = "Username:"
        usernameLabel.isEnabled = false
        usernameTextField.placeholder = "Username"
        usernameTextField.textContentType = .name
        usernameTextField.isEnabled = false
        passwordLabel.text = "Password:"
        passwordLabel.isEnabled = false
        passwordTextField.placeholder = "Password"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.isEnabled = false

        setToolbarItems([.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), toggleButtonItem, .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)], animated: true)
    }

    private func setupBinding() {
        viewModel.error.subscribe(onNext: { [weak self] in self?.coordinator?.whoops($0) }).disposed(by: bag)

        doneButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in self?.coordinator?.dismiss() })
            .disposed(by: bag)

        portTextField.rx.text.map { UInt($0 ?? "") }.bind(to: viewModel.port).disposed(by: bag)
        authenticationSwitch.rx.isOn.bind(to: usernameLabel.rx.isEnabled, usernameTextField.rx.isEnabled, passwordLabel.rx.isEnabled, passwordTextField.rx.isEnabled).disposed(by: bag)
        authenticationSwitch.rx.isOn.filter { !$0 }.map { _ in nil }.bind(to: viewModel.username, viewModel.password).disposed(by: bag)
        usernameTextField.rx.text.bind(to: viewModel.username).disposed(by: bag)
        passwordTextField.rx.text.bind(to: viewModel.password).disposed(by: bag)

        viewModel.isRunning.map { $0 ? "Stop" : "Start" }.bind(to: toggleButtonItem.rx.title).disposed(by: bag)
        toggleButtonItem.rx.tap.throttle(.milliseconds(300), scheduler: MainScheduler.instance).bind(to: viewModel.toggle).disposed(by: bag)
    }
}
