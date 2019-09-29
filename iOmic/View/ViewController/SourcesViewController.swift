//
//  SourcesViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController, SourcesViewProtocol {
    // MARK: Instance properties

    @IBOutlet private var tableView: UITableView!
    var presenter: SourcesViewOutputProtocol!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
    }

    private func setupView() {
        tableView.contentInset = .init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
