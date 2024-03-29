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
import GCDWebServer
import RxSwift

protocol UploaderProtocol {
    func start(with port: UInt?, username: String?, password: String?) -> Single<Void>
    func stop() -> Single<Void>
}

class Uploader: NSObject, UploaderProtocol {
    static let shared: Uploader = .init()
    private let path: Path
    private let webUploader: GCDWebUploader
    var delegate: GCDWebUploaderDelegate? {
        get { return webUploader.delegate }
        set { webUploader.delegate = newValue }
    }

    private override init() {
        path = Path.userDocuments + "Upload"
        if !path.exists {
            try? path.createDirectory(withIntermediateDirectories: true)
        }
        webUploader = .init(uploadDirectory: path.url.path)
        super.init()
        webUploader.allowedFileExtensions = ["pdf", "zip", "rar", "cbz", "cbr"]
    }

    // MARK: - UploaderProtocol

    func start(with port: UInt? = nil, username: String? = nil, password: String? = nil) -> Single<Void> {
        var options: [String: Any] = [
            GCDWebServerOption_Port: port ?? (Device.current.isSimulator ? 8080 : 80),
            GCDWebServerOption_ConnectionClass: Uploader.Connection.self,
        ]
        options[GCDWebServerOption_BonjourName] = ""
        if let username = username, let password = password {
            options[GCDWebServerOption_AuthenticationMethod] = GCDWebServerAuthenticationMethod_Basic
            options[GCDWebServerOption_AuthenticationAccounts] = [username: password]
        }
        return Single.create {
            do {
                $0(.success(try self.webUploader.start(options: options)))
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func stop() -> Single<Void> {
        return Single.create {
            $0(.success(self.webUploader.stop()))
            return Disposables.create {}
        }
    }
}

private extension Uploader {
    class Connection: GCDWebServerConnection {}
}
