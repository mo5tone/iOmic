//
//  Errors.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation

enum Whoops: Error {
    case nilWeakSelf
    case rawString(String)
    enum Networking: Error {
        case nilDataReponse(DataResponse<Data?>)
    }

    enum Codeing: Error {
        case decodeFailed
        case encodeFailed
    }

    enum JSON: Error {
        case nilProperty(String)
    }
}
