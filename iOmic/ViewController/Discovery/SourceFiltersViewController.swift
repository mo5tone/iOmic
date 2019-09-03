//
//  SourceFiltersViewController.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/8/31.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class SourceFiltersViewController: UIViewController {
    @IBOutlet var button: UIButton!
    private let disposeBag: DisposeBag = .init()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        button.rx.tap.subscribe(onNext: { print("hello there!") }).disposed(by: disposeBag)
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
