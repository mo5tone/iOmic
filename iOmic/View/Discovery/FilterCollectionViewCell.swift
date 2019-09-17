//
//  FilterCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? UIColor.flat.lightText : UIColor.flat.darkText
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedBackgroundView = {
            $0.backgroundColor = UIColor.flat.selected
            $0.layer.cornerRadius = 8.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.flat.clear.cgColor
            $0.layer.masksToBounds = true
            return $0
        }(UIView())
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
}
