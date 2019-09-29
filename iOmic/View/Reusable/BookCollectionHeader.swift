//
//  BookCollectionHeader.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/12.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class BookCollectionHeader: UICollectionReusableView {
    @IBOutlet private var titleLabel: UILabel!

    func setup(source: Source) {
        titleLabel.text = source.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .preferredFont(forTextStyle: .headline)
    }
}
