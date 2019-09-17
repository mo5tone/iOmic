//
//  UIView.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/17.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
    var tintColor: Binder<UIColor> { return .init(base, binding: { $0.tintColor = $1 }) }
}
