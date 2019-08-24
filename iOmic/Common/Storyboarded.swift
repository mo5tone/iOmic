//
//  Storyboarded.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/24.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static var storyboardName: String { get }
    static func instantiate(bundle: Bundle?) -> Self
}

// MARK: - UIViewController

extension Storyboarded where Self: UIViewController {
    static func instantiate(bundle: Bundle? = nil) -> Self {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
