//
//  DownloadViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/18.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation

class DownloadViewModel: ViewModel {
    let chapters: [Chapter]

    init(chapters: [Chapter]) {
        self.chapters = chapters
        super.init()
    }
}
