//
//  ChapterCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    // MARK: - instance props.

    @IBOutlet var titleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.flat.lightText : UIColor.flat.darkText
        }
    }

    // MARK: - public instance methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        titleLabel.font = .preferredFont(forTextStyle: .caption1)

        backgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.flat.background
            view.layer.cornerRadius = 4.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.flat.border.cgColor
            view.layer.masksToBounds = true
            return view
        }()
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.flat.selected
            view.layer.cornerRadius = 4.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.flat.border.cgColor
            view.layer.masksToBounds = true
            return view
        }()
    }
}
