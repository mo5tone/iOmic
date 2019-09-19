//
//  UILabel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/17.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UILabel {
    var isEnabled: Binder<Bool> { return .init(base, binding: { $0.isEnabled = $1 }) }
}
