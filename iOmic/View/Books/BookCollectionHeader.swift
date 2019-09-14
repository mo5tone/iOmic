//
//  BookCollectionHeader.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/12.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class BookCollectionHeader: UICollectionReusableView {
    @IBOutlet var titleLabel: UILabel!

    func setup(identifier: SourceIdentifier) {
        titleLabel.text = identifier.source.name
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .preferredFont(forTextStyle: .headline)
    }
}
