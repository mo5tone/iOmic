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

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titlteLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!

    private var processor: ImageProcessor {
        let imageViewsize = imageView.frame.size
        return DownsamplingImageProcessor(size: imageViewsize)
    }

    private var options: [KingfisherOptionsInfoItem] {
        return [.transition(.fade(0.2)), .processor(processor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage]
    }

    // MARK: - Public

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity

        titlteLabel.font = .preferredFont(forTextStyle: .subheadline)
        authorLabel.font = .preferredFont(forTextStyle: .caption2)
        statusLabel.font = .preferredFont(forTextStyle: .caption2)
    }

    func setup(book: Book, displaySource _: Bool = false) {
        var options = self.options
        options.append(.requestModifier(book.source.modifier))
        imageView.kf.setImage(with: URL(string: book.thumbnailUrl ?? ""), options: options)
        titlteLabel.text = book.title
        authorLabel.text = book.author
        statusLabel.text = book.status.rawValue
    }

    func cancelDownloadTask() {
        imageView.kf.cancelDownloadTask()
    }
}
