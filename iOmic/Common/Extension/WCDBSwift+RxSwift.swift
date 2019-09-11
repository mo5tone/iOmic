//
//  WCDBSwift+RxSwift.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/10.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

/// https://github.com/ReactiveCocoa/ReactiveSwift/issues/238
// extension Table: ReactiveCompatible {}

extension Table {
    struct Reactive<Root> where Root: TableDecodable, Root: TableEncodable {
        let base: Table<Root>
        fileprivate init(_ base: Table<Root>) { self.base = base }
    }

    var rx: Reactive<Root> { return Reactive(self) }
}

extension Table.Reactive {
    func getObject(on propertyConvertibleList: [PropertyConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Observable<Root?> {
        return Observable.create { observer -> Disposable in
            do {
                let object = try self.base.getObject(on: propertyConvertibleList, where: condition, orderBy: orderList, offset: offset)
                observer.on(.next(object))
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getObject(on propertyConvertibleList: PropertyConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Observable<Root?> {
        return Observable.create { observer -> Disposable in
            do {
                let object = try self.base.getObject(on: propertyConvertibleList, where: condition, orderBy: orderList, offset: offset)
                observer.on(.next(object))
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create {}
        }
    }

    func insertOrReplace(objects: [Root], on propertyConvertibleList: [PropertyConvertible]? = nil) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            do {
                try self.base.insertOrReplace(objects: objects, on: propertyConvertibleList)
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create {}
        }
    }

    func insertOrReplace(objects: Root..., on propertyConvertibleList: [PropertyConvertible]? = nil) -> Observable<Void> {
        return Observable.create { observer -> Disposable in
            do {
                try self.base.insertOrReplace(objects: objects, on: propertyConvertibleList)
                observer.on(.completed)
            } catch {
                observer.on(.error(error))
            }
            return Disposables.create {}
        }
    }
}
