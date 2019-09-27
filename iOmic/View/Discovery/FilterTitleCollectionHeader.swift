//
//  FilterTitleCollectionHeader.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/4.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import UIKit

class FilterTitleCollectionHeader: UICollectionReusableView {
    @IBOutlet private var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = .preferredFont(forTextStyle: .headline)
    }

    func setup(_ filter: FilterProrocol) {
        titleLabel.text = filter.title
    }
}
