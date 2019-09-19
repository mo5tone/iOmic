//
//  UIFont.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    func textSize(in frame: CGRect = .init(origin: .zero, size: .zero), with text: String? = nil) -> CGSize {
        let label: UILabel = .init(frame: frame)
        label.font = self
        label.text = text ?? "Ay"
        return label.intrinsicContentSize
    }
}
