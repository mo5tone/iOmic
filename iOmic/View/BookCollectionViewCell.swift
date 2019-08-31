//
//  BookCollectionViewCell.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import UIKit

/// `UIStackView need constraints for x or width` issue: https://stackoverflow.com/questions/52024363/uistackview-inside-uicollectionviewcell-autolayout-issues-after-running-on-xcode

class BookCollectionViewCell: UICollectionViewCell {
    // MARK: - Props.

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titlteLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!

    private var processor: ImageProcessor {
        let imageViewsize = imageView.frame.size
        return DownsamplingImageProcessor(size: imageViewsize)
            >> RoundCornerImageProcessor(cornerRadius: 8, targetSize: imageViewsize, roundingCorners: [.topLeft, .topRight])
    }

    private var options: [KingfisherOptionsInfoItem] {
        return [.transition(.fade(0.2)), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage]
    }

    // MARK: - Public

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        contentView.subviews.forEach { $0.backgroundColor = .clear }
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        titlteLabel.font = .preferredFont(forTextStyle: .title3)
        authorLabel.font = .preferredFont(forTextStyle: .subheadline)
        statusLabel.font = .preferredFont(forTextStyle: .caption1)
    }

    func setup(book: Book, displaySource _: Bool = false) {
        var options = self.options
        options.append(.requestModifier(book.source.modifier))
        imageView.kf.setImage(with: URL(string: book.thumbnailUrl ?? ""), options: options)
        titlteLabel.text = book.title
        authorLabel.text = book.author
        statusLabel.text = "\(book.status)"
    }
}
