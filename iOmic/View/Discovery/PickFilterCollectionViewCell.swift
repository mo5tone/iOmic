//
//  PickFilterCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class PickFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            view.layer.cornerRadius = 8.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.masksToBounds = true
            return view
        }()
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
}
