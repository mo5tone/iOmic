//
//  UITableView.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableViewHeaderFooterView: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerCell<Reuse>(_ reusable: Reuse.Type) where Reuse: UITableViewCell {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
    }

    func registerHeaderFooterView<Reuse>(_ reusable: Reuse.Type) where Reuse: UITableViewHeaderFooterView {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: reusableIdentifier)
    }
}
