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
    case nilProperty(String)

    enum Networking: Error {
        case nilDataReponse(AFDataResponse<Data?>)
    }

    enum Source: Error {
        case noPageContentToShow
    }

    enum Codeing: Error {
        case decodeFailed
        case encodeFailed
    }

    enum JSON: Error {
        case nilProperty(String)
    }
}
