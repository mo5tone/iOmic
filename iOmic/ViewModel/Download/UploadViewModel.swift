//
//  UploadViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/16.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift

class UploadViewModel: ViewModel {
    private let uploader: UploaderProtocol
    let port: BehaviorSubject<UInt?> = .init(value: nil)
    let username: BehaviorSubject<String?> = .init(value: nil)
    let password: BehaviorSubject<String?> = .init(value: nil)
    let isRunning: BehaviorSubject<Bool> = .init(value: false)
    let toggle: PublishSubject<Void> = .init()

    init(uploader: UploaderProtocol) {
        self.uploader = uploader
        super.init()
        let start = toggle.withLatestFrom(isRunning).filter { !$0 }
        let stop = toggle.withLatestFrom(isRunning).filter { $0 }
        start.withLatestFrom(Observable.combineLatest(port, username, password))
            .flatMapLatest { port, username, password in uploader.start(with: port, username: username, password: password) }
            .debug("start")
            .asCompletable()
            .subscribe(onCompleted: { [weak self] in self?.isRunning.on(.next(true)) }, onError: { [weak self] in self?.error.on(.next($0)) })
            .disposed(by: bag)
        stop.flatMapLatest { _ in uploader.stop() }
            .debug("stop")
            .asCompletable()
            .subscribe(onCompleted: { [weak self] in self?.isRunning.on(.next(false)) }, onError: { [weak self] in self?.error.on(.next($0)) })
            .disposed(by: bag)
    }
}
