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
    func createTask(_ task: Downloader.Task)

    func startTask(task: Downloader.Task)

    func pauseTask(task: Downloader.Task)

    func removeTask(task: Downloader.Task)
}

protocol DownloaderDatabaseManager {
//    func download(of chapter: Chapter) -> Single<Chapter.Download?>
//    func appendDownload(of chapter: Chapter) -> Completable
//    func startDownload(of chapter: Chapter) -> Completable
//    func pauseDownload(of chapter: Chapter) -> Completable
//    func removeDownload(of chapter: Chapter) -> Completable
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

extension Downloader: DownloaderProtocol {
    func createTask(_: Downloader.Task) {}

    func startTask(task _: Downloader.Task) {}

    func pauseTask(task _: Downloader.Task) {}

    func removeTask(task _: Downloader.Task) {}
}
