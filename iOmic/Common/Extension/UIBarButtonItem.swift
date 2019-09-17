//
//  UIBarButtonItem.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/17.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension UIBarButtonItem {
    static var flexibleSpace: UIBarButtonItem { return .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) }
}

extension Reactive where Base: UIBarButtonItem {
    var image: Binder<UIImage?> { return .init(base, binding: { $0.image = $1 }) }

    var tintColor: Binder<UIColor> { return .init(base, binding: { $0.tintColor = $1 }) }
}
