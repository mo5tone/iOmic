//
//  Uploader.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/16.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import DeviceKit
import FileKit
import Foundation
import GCDWebServers
import RxSwift

protocol UploaderProtocol {
    func start(with port: UInt?, username: String?, password: String?) -> Completable
    func stop() -> Completable
}

class Uploader: NSObject, UploaderProtocol {
    static let shared: Uploader = .init()
    private var path: Path
    private let webUploader: GCDWebUploader

    private override init() {
        path = Path.userDocuments + "Upload"
        if !path.exists {
            try? path.createDirectory(withIntermediateDirectories: true)
        }
        webUploader = .init(uploadDirectory: path.url.path)
        super.init()
        webUploader.allowedFileExtensions = ["pdf", "zip", "rar", "cbz", "cbr"]
        webUploader.delegate = self
    }

    // MARK: - UploaderProtocol

    func start(with port: UInt? = nil, username: String? = nil, password: String? = nil) -> Completable {
        var options: [String: Any] = [
            GCDWebServerOption_Port: port ?? (Device.current.isSimulator ? 8080 : 80),
        ]
        options[GCDWebServerOption_BonjourName] = ""
        if let username = username, let password = password {
            options[GCDWebServerOption_AuthenticationMethod] = GCDWebServerAuthenticationMethod_Basic
            options[GCDWebServerOption_AuthenticationAccounts] = [username: password]
        }
        return Completable.create { [weak self] observer -> Disposable in
            do {
                try self?.webUploader.start(options: options)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func stop() -> Completable {
        return Completable.create { [weak self] observer -> Disposable in
            self?.webUploader.stop()
            observer(.completed)
            return Disposables.create {}
        }
    }
}

// MARK: - GCDWebUploaderDelegate

extension Uploader: GCDWebUploaderDelegate {}
