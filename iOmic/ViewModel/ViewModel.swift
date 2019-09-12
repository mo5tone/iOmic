//
//  ViewModel.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/12.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxSwift
import UIKit

class ViewModel: NSObject {
    let bag: DisposeBag = .init()
    let error: PublishSubject<Error> = .init()
}
