//
//  Downloader.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/17.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import FileKit
import Foundation
import Kingfisher
import RxSwift

protocol DownloaderProtocol {
    func createTask(with chapter: Chapter) -> Completable

    func startTask(with chapter: Chapter) -> Completable

    func pauseTask(with chapter: Chapter) -> Completable

    func removeTask(with chapter: Chapter) -> Completable
}

protocol DownloaderDatabaseManager {
    func setChapter(_ chapter: Chapter, download: Chapter.Download) -> Completable
}

class Downloader: NSObject {
    // MARK: - types

    struct Task {
        let chapter: Chapter
        let pages: [Page]
    }

    // MARK: - props

    private let path: Path
    private lazy var databaseManager: DownloaderDatabaseManager = DatabaseManager.shared
    private lazy var imageDownloader: ImageDownloader = ImageDownloader.default

    private override init() {
        path = Path.userDocuments + "Download"
        super.init()
        if !path.exists {
            try? path.createDirectory(withIntermediateDirectories: true)
        }
    }
}

// extension Downloader: DownloaderProtocol {}
