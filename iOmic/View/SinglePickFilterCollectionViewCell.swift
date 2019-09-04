//
//  SinglePickFilterCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class SinglePickFilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
}
