//
//  ReusableIdentifier.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/30.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableIdentifier {
    static var reusableIdentifier: String { get }
}

extension UICollectionReusableView: ReusableIdentifier {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func registerCell<Reusable: ReusableIdentifier>(_ reusable: Reusable.Type) {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
    }

    func registerHeaderFooterView<Reusable: ReusableIdentifier>(_ reusable: Reusable.Type, supplementaryViewOfKind: String) {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: reusableIdentifier)
    }
}

extension UITableViewCell: ReusableIdentifier {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableViewHeaderFooterView: ReusableIdentifier {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerCell<Reusable: ReusableIdentifier>(_ reusable: Reusable.Type) {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
    }

    func registerHeaderFooterView<Reusable: ReusableIdentifier>(_ reusable: Reusable.Type) {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: reusableIdentifier)
    }
}
