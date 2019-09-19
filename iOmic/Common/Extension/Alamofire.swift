//
//  URLRequestConvertible.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol RequestConvertible: URLRequestConvertible {
    var baseURLString: URLConvertible { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var parameterEncoding: ParameterEncoding { get }
    var interceptor: RequestInterceptor? { get }
//    var validation: DataRequest.Validation { get }
}

extension URLRequestConvertible where Self: RequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURLString.asURL()
        let request = try URLRequest(url: url.appendingPathComponent(path), method: method, headers: headers)
        return try parameterEncoding.encode(request, with: parameters)
    }
}

extension DataRequest {
    func response(queue: DispatchQueue = .main) -> Single<DataResponse<Data?>> {
        return Single.create { [weak self] observer -> Disposable in
            self?.response(queue: queue) { observer(.success($0)) }
            return Disposables.create { self?.cancel() }
        }
    }

    func responseData(queue: DispatchQueue = .main) -> Single<DataResponse<Data>> {
        return Single.create { [weak self] observer -> Disposable in
            self?.responseData(queue: queue) { observer(.success($0)) }
            return Disposables.create { self?.cancel() }
        }
    }

    func responseString(queue: DispatchQueue = .main, encoding: String.Encoding? = nil) -> Single<DataResponse<String>> {
        return Single.create { [weak self] observer -> Disposable in
            self?.responseString(queue: queue, encoding: encoding) { observer(.success($0)) }
            return Disposables.create { self?.cancel() }
        }
    }

    func responseJSON(queue: DispatchQueue = .main, options: JSONSerialization.ReadingOptions = .allowFragments) -> Single<DataResponse<Any>> {
        return Single.create { [weak self] observer -> Disposable in
            self?.responseJSON(queue: queue, options: options) { observer(.success($0)) }
            return Disposables.create { self?.cancel() }
        }
    }

    func responseDecodable<T>(queue: DispatchQueue = .main, decoder: DataDecoder = JSONDecoder()) -> Single<DataResponse<T>> where T: Decodable {
        return Single.create { [weak self] observer -> Disposable in
            self?.responseDecodable(queue: queue, decoder: decoder) { (response: DataResponse<T>) in observer(.success(response)) }
            return Disposables.create { self?.cancel() }
        }
    }
}