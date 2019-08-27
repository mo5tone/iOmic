//
//  Errors.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/8/27.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Alamofire
import Foundation

enum Errors {
    enum Networking: Error {
        case responseNoData(DataResponse<Data?>)
    }
}
