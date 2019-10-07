//
//  SourcesViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DifferenceKit
import RxSwift
import UIKit

class SourcesViewController: UIViewController, SourcesViewProtocol {
    // MARK: Instance properties

    private let bag: DisposeBag = .init()
    @IBOutlet private var tableView: UITableView!
    var presenter: SourcesViewOutputProtocol!
    private lazy var doneBarButtonItem: UIBarButtonItem = .init(barButtonSystemItem: .done, target: nil, action: nil)
    private var sources: [Source] = []

    // MARK: - Public instance methods

    func reload(sources: [Source], current source: Source) {
        tableView.reload(using: .init(source: self.sources, target: sources), with: .fade, setData: { self.sources = $0 })
        if let row = self.sources.firstIndex(of: source) {
            tableView.selectRow(at: .init(row: row, section: 0), animated: true, scrollPosition: .middle)
        }
    }

    // MARK: - Overrides

    deinit { Logger.info() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Private instance methods

    private func setup() {
        setupView()
        setupBinding()
    }

    private func setupView() {
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.title = "Sources"

        tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        tableView.separatorInset = .zero
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.registerCell(SourceTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupBinding() {
        doneBarButtonItem.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.presenter.didTapDoneBarButtonItem() })
            .disposed(by: bag)
    }
}

// MARK: - UITableViewDataSource

extension SourcesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return sources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.reusableIdentifier, for: indexPath)
        if let cell = cell as? SourceTableViewCell {
            cell.setup(with: sources[indexPath.row])
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SourcesViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(indexPath.row)
    }
}
