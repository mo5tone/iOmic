//
//  Kingfisher.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/17.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import Kingfisher
import RxSwift

extension ImageDownloader: ReactiveCompatible {}

extension Reactive where Base: ImageDownloader {
    func downloadImage(with url: URL, options: KingfisherParsedOptionsInfo) -> Single<ImageLoadingResult> {
        return Single.create { observer -> Disposable in
            let task = self.base.downloadImage(with: url, options: options) { result in
                switch result {
                case let .success(value):
                    observer(.success(value))
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create { task?.cancel() }
        }
    }

    func downloadImage(with url: URL, options: KingfisherOptionsInfo? = nil, progress: BehaviorSubject<Double>) -> Single<ImageLoadingResult> {
        return Single.create { observer -> Disposable in
            let task = self.base.downloadImage(with: url, options: options, progressBlock: { progress.on(.next(Double($0) / Double($1))) }, completionHandler: { result in
                switch result {
                case let .success(value):
                    observer(.success(value))
                case let .failure(error):
                    observer(.error(error))
                }
            })
            return Disposables.create { task?.cancel() }
        }
    }
}
