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
            titleLabel.textColor = isSelected ? .lightText : .darkText
        }
    }

    // MARK: - public instance methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .darkText
        backgroundView = {
            let view = UIView()
            view.backgroundColor = .groupTableViewBackground
            view.layer.cornerRadius = 4.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.darkGray.cgColor
            view.layer.masksToBounds = true
            return view
        }()
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            view.layer.cornerRadius = 4.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.darkGray.cgColor
            view.layer.masksToBounds = true
            return view
        }()
    }
}
