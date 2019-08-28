//
//  ManHuaRenSource.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/25.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

class ManHuaRen: Source {
    // MARK: - Types

    fileprivate enum Router {
        case books(Int, String, [FilterProrocol])
        case chapters(Book)
        case pages(Chapter)
    }

    // MARK: - Static

    static let shared = ManHuaRen()
    // MARK: - props.
    fileprivate let sizePerPage = 20

    // MARK: - Private

    private override init() {
        super.init()
    }

    // MARK: - Public
}



// extension ManHuaRen: OnlineSourceProtocol {}

extension ManHuaRen.Router: RequestConvertible {
    fileprivate class Interceptor: RequestInterceptor {
        private let cipher = "4e0a48e1c0b54041bce9c8f0e036124d"
        
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (AFResult<URLRequest>) -> Void) {
            var request = urlRequest
            if let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                var key = cipher + "GET"
                let queryItems = components.queryItems ?? []
                queryItems.filter({ $0.name != "gsn" }).sorted(by: { $0.name < $1.name }).forEach({
                    guard let value = $0.value else { return }
                    key += $0.name
                    key += value
                })
                key += cipher
                do {
                    completion(.success(try URLEncoding.default.encode(request, with: ["gsn": key.md5String()])))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.success(request))
            }
        }
    }
    
    var baseURLString: URLConvertible { return "http://mangaapi.manhuaren.com" }
    
    var path: String {
        <#code#>
    }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "X-Yq-Yqci", value: #"{"le": "zh"}"#)
        headers.add(name: "Referer", value: "http://www.dm5.com/dm5api/")
        headers.add(name: "clubReferer", value: "http://mangaapi.manhuaren.com/")
        return headers
    }
    
    var method: HTTPMethod { return .get }
    
    var parameters: Parameters {
        var parameters: Parameters = ["gsm": "md5", "gft": "json", "gts": Date().convert2String(), "gak": "android_manhuaren2", "gat": "", "gaui": "191909801", "gui": "191909801", "gut": "0"]
        
        return parameters
    }
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    var interceptor: RequestInterceptor? { return Interceptor() }
    
}
