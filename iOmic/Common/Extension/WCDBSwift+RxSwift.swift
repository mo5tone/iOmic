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

extension Table: ReactiveCompatible {}

/// https://github.com/ReactiveCocoa/ReactiveSwift/issues/238
extension Reactive {
    func getObject<Root>(on propertyConvertibleList: [PropertyConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Observable<Root?> where Base: Table<Root>, Root: TableDecodable, Root: TableEncodable {
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

    func getObject<Root>(on propertyConvertibleList: PropertyConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Observable<Root?> where Base: Table<Root>, Root: TableDecodable, Root: TableEncodable {
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

    func insertOrReplace<Root>(objects: [Root], on propertyConvertibleList: [PropertyConvertible]? = nil) -> Observable<Void> where Base: Table<Root>, Root: TableDecodable, Root: TableEncodable {
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

    func insertOrReplace<Root>(objects: Root..., on propertyConvertibleList: [PropertyConvertible]? = nil) -> Observable<Void> where Base: Table<Root>, Root: TableDecodable, Root: TableEncodable {
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
