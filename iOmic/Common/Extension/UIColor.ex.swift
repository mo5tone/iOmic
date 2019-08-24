//
//  UIColor.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var tintColor: UIColor {
        return UIApplication.shared.keyWindow?.rootViewController?.view.tintColor ?? .blue
    }
}
