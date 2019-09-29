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

    @IBOutlet private var titleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? UIColor.flat.lightText : UIColor.flat.darkText
        }
    }

    func setup(_ chapter: Chapter) {
        titleLabel.text = chapter.name
    }

    // MARK: - public instance methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        titleLabel.font = .preferredFont(forTextStyle: .caption1)

        backgroundView = {
            $0.backgroundColor = UIColor.flat.background
            $0.layer.cornerRadius = 4.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.flat.border.cgColor
            $0.layer.masksToBounds = true
            return $0
        }(UIView())
        selectedBackgroundView = {
            $0.backgroundColor = UIColor.flat.selected
            $0.layer.cornerRadius = 4.0
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.flat.border.cgColor
            $0.layer.masksToBounds = true
            return $0
        }(UIView())
    }
}
