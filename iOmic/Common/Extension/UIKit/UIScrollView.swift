//
//  UIScrollView.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/10/2.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
    func loadMore(when limit: CGFloat, isVertical: Bool = true) -> Observable<Void> {
        return contentOffset.map { [weak scrollView = self.base] _ -> CGFloat in
            guard let scrollView = scrollView else { return 0 }
            return isVertical ? scrollView.contentOffset.y - max(0, scrollView.contentSize.height - scrollView.frame.height) : scrollView.contentOffset.x - max(0, scrollView.contentSize.width - scrollView.frame.width)
        }
        .filter { $0 > limit }
        .map { _ in () }
    }
}
