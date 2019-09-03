//
//  UIAlertAction.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/3.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertAction {
    
    /// Image to display left of the action title
    var leadingImage: UIImage? {
        get {
            guard self.responds(to: Selector(Keys.image)) else { return nil }
            return self.value(forKey: Keys.image) as? UIImage
        }
        set { if self.responds(to: Selector(Keys.image)) { self.setValue(newValue, forKey: Keys.image) } }
    }
    
    private struct Keys {
        static var image = "image"
    }
}
