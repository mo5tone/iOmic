//
//  ErrorViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/12.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    private var error: Error

    init(error: Error) {
        self.error = error
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor.flat.clear

        imageView.image = #imageLiteral(resourceName: "ic_error_outline")
        imageView.tintColor = UIColor.flat.lightText

        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.flat.lightText
        label.text = error.localizedDescription
    }
}
