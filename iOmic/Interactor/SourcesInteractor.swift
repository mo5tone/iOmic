//
//  SourcesInteractor.swift
//  iOmic
//
//  Created by 门捷夫 on 2019/9/29.
//  Copyright © 2019 门捷夫. All rights reserved.
//

class SourcesInteractor: SourcesInteractorProtocol {
    // MARK: - Instance properties

    weak var presenter: SourcesInteractorOutputProtocol?
    private var keyValues: KeyValuesProtocol
    var sources: [Source] { return Source.values }

    // MARK: - Public instance methods

    func set(souce: Source, available: Bool) {
        keyValues.set(souce: souce, available: available)
    }

    // MARK: - Init

    init(keyValues: KeyValuesProtocol) {
        self.keyValues = keyValues
    }
}
