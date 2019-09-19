//
//  ChaptersDownloadViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class ChaptersDownloadViewModel: ViewModel {
    let chapters: [Chapter]
    private(set) var chaptersToDownload: [Chapter] = []
    let selectedIndexPath: PublishSubject<IndexPath> = .init()
    let deselectedIndexPath: PublishSubject<IndexPath> = .init()
    let markAll: PublishSubject<Void> = .init()

    init(chapters: [Chapter]) {
        self.chapters = chapters
        super.init()
        selectedIndexPath.subscribe(onNext: { [weak self] in
            let chapter = chapters[$0.item]
            self?.chaptersToDownload.append(chapter)
        }).disposed(by: bag)
        deselectedIndexPath.subscribe(onNext: { [weak self] in
            let chapter = chapters[$0.item]
            self?.chaptersToDownload.removeAll(where: { $0 == chapter })
        }).disposed(by: bag)
        markAll.subscribe(onNext: { [weak self] in
            if self?.chaptersToDownload.isEmpty ?? true {
                self?.chaptersToDownload = chapters
            } else {
                self?.chaptersToDownload = []
            }
        }).disposed(by: bag)
    }
}
