//
//  Reusable.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/30.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension UICollectionReusableView: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func registerForCell<Reuse>(_ reusable: Reuse.Type) where Reuse: UICollectionViewCell {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
    }

    func registerForHeaderFooterView<Reuse>(_ reusable: Reuse.Type, forSupplementaryViewOfKind kind: String) where Reuse: UICollectionReusableView {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableIdentifier)
    }
}

extension UITableViewCell: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableViewHeaderFooterView: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerForCell<Reuse>(_ reusable: Reuse.Type) where Reuse: UITableViewCell {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellReuseIdentifier: reusableIdentifier)
    }

    func registerForHeaderFooterView<Reuse>(_ reusable: Reuse.Type) where Reuse: UITableViewHeaderFooterView {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: reusableIdentifier)
    }
}
