//
//  PageCollectionViewCell.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/7.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Kingfisher
import UIKit

protocol PageCollectionViewCellDelegate: AnyObject {
    func pageCollectionViewCellOnTap(_ cell: PageCollectionViewCell)
}

/// https://stackoverflow.com/questions/19036228
class PageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    weak var delegate: PageCollectionViewCellDelegate?
    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(onSingleTap(recognizer:)))
        gestureRecognizer.numberOfTapsRequired = 1
        return gestureRecognizer
    }()

    private lazy var doubleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(onDoubleTap(recognizer:)))
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }()

    func setup(_ page: Page) {
        imageView.kf.setImage(with: URL(string: page.imageUrl ?? ""), options: [.transition(.fade(0.3)), .requestModifier(page.source.imageDownloadRequestModifier)])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.flat.none
        singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)

        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.zoomScale = 1
        scrollView.delegate = self

        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
    }

    // MARK: - private instance methods

    @objc private func onSingleTap(recognizer _: UITapGestureRecognizer) {
        delegate?.pageCollectionViewCellOnTap(self)
    }

    @objc private func onDoubleTap(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectWith(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollView.zoom(to: zoomRectWith(scale: scrollView.minimumZoomScale, center: imageView.center), animated: true)
        }
    }

    private func zoomRectWith(scale: CGFloat, center: CGPoint) -> CGRect {
        var rect: CGRect = .zero
        rect.size.width = imageView.frame.size.width / scale
        rect.size.height = imageView.frame.size.height / scale
        let rectCenter: CGPoint = imageView.convert(center, to: scrollView)
        rect.origin.x = rectCenter.x - rect.size.width / 2
        rect.origin.y = rectCenter.y - rect.size.height / 2
        return rect
    }
}

// MARK: - UIScrollViewDelegate

extension PageCollectionViewCell: UIScrollViewDelegate {
    func viewForZooming(in _: UIScrollView) -> UIView? {
        return imageView
    }
}
