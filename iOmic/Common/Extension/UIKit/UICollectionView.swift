//
//  UICollectionView.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionReusableView: Reusable {
    static var reusableIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func registerCell<Reuse>(_ reusable: Reuse.Type) where Reuse: UICollectionViewCell {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
    }

    func registerSupplementaryView<Reuse>(_ reusable: Reuse.Type, of kind: String) where Reuse: UICollectionReusableView {
        let reusableIdentifier = reusable.reusableIdentifier
        register(UINib(nibName: reusableIdentifier, bundle: nil), forSupplementaryViewOfKind: kind, withReuseIdentifier: reusableIdentifier)
    }
}
