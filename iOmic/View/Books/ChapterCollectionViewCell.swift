//
//  ChapterCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/5.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import MarqueeLabel
import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: MarqueeLabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.type = .continuous
        titleLabel.speed = .duration(3)
        titleLabel.animationCurve = .easeInOut
        titleLabel.fadeLength = 4
//        titleLabel.labelize = true
        backgroundView = {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.layer.cornerRadius = 8.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.masksToBounds = true
            return view
        }()
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = .darkGray
            view.layer.cornerRadius = 8.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.clear.cgColor
            view.layer.masksToBounds = true
            return view
        }()
    }
}
