//
//  DiscoveryViewController.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController, DiscoveryViewProtocol {
    var presenter: DiscoveryViewOutputProtocol!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
