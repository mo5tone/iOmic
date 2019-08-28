//
//  Errors.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation

enum Whoops {
    enum Networking: Error {
        case responseWithoutData(DataResponse<Data?>)
    }

    enum Codeing: Error {
        case decodeFailed
        case encodeFailed
    }

    enum JSON: Error {
        case nilProperty(String)
    }
}
