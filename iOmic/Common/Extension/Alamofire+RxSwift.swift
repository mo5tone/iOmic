//
//  Alamofire+RxSwift.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

extension DataRequest {
    func response(queue _: DispatchQueue = .main) -> Observable<DataResponse<Data?>> {
        return Observable<DataResponse<Data?>>.create { [weak self] observer -> Disposable in
            self?.response { observer.on(.next($0)); observer.on(.completed) }
            return Disposables.create {}
        }
    }

    func responseData(queue _: DispatchQueue = .main) -> Observable<DataResponse<Data>> {
        return Observable<DataResponse<Data>>.create { [weak self] observer -> Disposable in
            self?.responseData { observer.on(.next($0)); observer.on(.completed) }
            return Disposables.create {}
        }
    }

    func responseString(queue: DispatchQueue = .main, encoding: String.Encoding? = nil) -> Observable<DataResponse<String>> {
        return Observable<DataResponse<String>>.create { [weak self] observer -> Disposable in
            self?.responseString(queue: queue, encoding: encoding) { observer.on(.next($0)); observer.on(.completed) }
            return Disposables.create {}
        }
    }

    func responseJSON(queue: DispatchQueue = .main, options: JSONSerialization.ReadingOptions = .allowFragments) -> Observable<DataResponse<Any>> {
        return Observable<DataResponse<Any>>.create { [weak self] observer -> Disposable in
            self?.responseJSON(queue: queue, options: options) { observer.on(.next($0)); observer.on(.completed) }
            return Disposables.create {}
        }
    }
}
