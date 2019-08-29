//
//  URLRequestConvertible.ex.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

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
