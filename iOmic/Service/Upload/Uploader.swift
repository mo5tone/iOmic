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
    func start(with port: UInt?, username: String?, password: String?) -> Observable<Void>
    func stop() -> Observable<Void>
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

    func start(with port: UInt? = nil, username: String? = nil, password: String? = nil) -> Observable<Void> {
        var options: [String: Any] = [
            GCDWebServerOption_Port: port ?? (Device.current.isSimulator ? 8080 : 80),
        ]
        options[GCDWebServerOption_BonjourName] = ""
        if let username = username, let password = password {
            options[GCDWebServerOption_AuthenticationMethod] = GCDWebServerAuthenticationMethod_Basic
            options[GCDWebServerOption_AuthenticationAccounts] = [username: password]
        }
        return Observable.create { [weak self] observer -> Disposable in
            do {
                try self?.webUploader.start(options: options)
                observer.on(.next(()))
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create {}
        }
    }

    func stop() -> Observable<Void> {
        return Observable.create { [weak self] observer -> Disposable in
            self?.webUploader.stop()
            observer.on(.next(()))
            observer.on(.completed)
            return Disposables.create {}
        }
    }
}

// MARK: - GCDWebUploaderDelegate

extension Uploader: GCDWebUploaderDelegate {}
