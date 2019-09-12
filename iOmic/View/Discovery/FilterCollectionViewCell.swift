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
            let view = UIView()
            view.backgroundColor = UIColor.flat.selected
            view.layer.cornerRadius = 8.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.flat.clear.cgColor
            view.layer.masksToBounds = true
            return view
        }()
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
}
