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

    // MARK: - Private

    private override init() {
        super.init()
    }

    // MARK: - Public
}

// extension ManHuaRen: OnlineSourceProtocol {}

// extension MHRSource.Router: RequestConvertible {}
