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

extension Database: ReactiveCompatible {}

extension Reactive where Base: TableInterface {
    func create<Root>(virtualTable name: String, of rootType: Root.Type) -> Completable where Root: TableDecodable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.create(virtualTable: name, of: rootType)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create<Root>(table name: String, of rootType: Root.Type) -> Completable where Root: TableDecodable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.create(table: name, of: rootType)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(table name: String, with columnDefList: [ColumnDef], and constraintList: [TableConstraint]? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.create(table: name, with: columnDefList, and: constraintList)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(table name: String, with columnDefList: ColumnDef..., and constraintList: [TableConstraint]? = nil) -> Completable {
        return create(table: name, with: columnDefList, and: constraintList)
    }
}

/// https://github.com/ReactiveCocoa/ReactiveSwift/issues/238

extension Table {
    struct Reactive<Root> where Root: TableDecodable, Root: TableEncodable {
        let base: Table<Root>
        fileprivate init(_ base: Table<Root>) { self.base = base }
    }

    // keep same with RxSwift namespace
    // swiftlint:disable:next identifier_name
    var rx: Reactive<Root> { return Reactive(self) }
}

// MARK: - InsertTableInterface

extension Table.Reactive {
    func insert(objects: [Root], on propertyConvertibleList: [PropertyConvertible]? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.insert(objects: objects, on: propertyConvertibleList)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func insert(objects: Root..., on propertyConvertibleList: [PropertyConvertible]? = nil) -> Completable {
        return insert(objects: objects, on: propertyConvertibleList)
    }

    func insertOrReplace(objects: [Root], on propertyConvertibleList: [PropertyConvertible]? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.insertOrReplace(objects: objects, on: propertyConvertibleList)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func insertOrReplace(objects: Root..., on propertyConvertibleList: [PropertyConvertible]? = nil) -> Completable {
        return insertOrReplace(objects: objects, on: propertyConvertibleList)
    }
}

// MARK: - UpdateTableInterface

extension Table.Reactive {
    func update(on propertyConvertibleList: [PropertyConvertible], with object: Root, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.update(on: propertyConvertibleList, with: object, where: condition, orderBy: orderList, limit: limit, offset: offset)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func update(on propertyConvertibleList: PropertyConvertible..., with object: Root, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Completable {
        return update(on: propertyConvertibleList, with: object, where: condition, orderBy: orderList, limit: limit, offset: offset)
    }

    func update(on propertyConvertibleList: [PropertyConvertible], with row: [ColumnEncodable], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.update(on: propertyConvertibleList, with: row, where: condition, orderBy: orderList, limit: limit, offset: offset)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func update(on propertyConvertibleList: PropertyConvertible..., with row: [ColumnEncodable], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Completable {
        return update(on: propertyConvertibleList, with: row, where: condition, orderBy: orderList, limit: limit, offset: offset)
    }
}

// MARK: - DeleteTableInterface

extension Table.Reactive {
    func delete(where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Completable {
        return Completable.create { observer -> Disposable in
            do {
                try self.base.delete(where: condition, orderBy: orderList, limit: limit, offset: offset)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }
}

// MARK: - SelectTableInterface

extension Table.Reactive {
    func getObjects(on propertyConvertibleList: [PropertyConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<[Root]> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getObjects(on: propertyConvertibleList, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getObjects(on propertyConvertibleList: PropertyConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<[Root]> {
        return getObjects(on: propertyConvertibleList, where: condition, orderBy: orderList, limit: limit, offset: offset)
    }

    func getObject(on propertyConvertibleList: [PropertyConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Single<Root?> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getObject(on: propertyConvertibleList, where: condition, orderBy: orderList, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getObject(on propertyConvertibleList: PropertyConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Single<Root?> {
        return getObject(on: propertyConvertibleList, where: condition, orderBy: orderList, offset: offset)
    }
}

// MARK: - RowSelectTableInterface

extension Table.Reactive {
    func getRows(on columnResultConvertibleList: [ColumnResultConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalRowXColumn> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getRows(on: columnResultConvertibleList, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getRows(on columnResultConvertibleList: ColumnResultConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalRowXColumn> {
        return getRows(on: columnResultConvertibleList, where: condition, orderBy: orderList, limit: limit, offset: offset)
    }

    func getRow(on columnResultConvertibleList: [ColumnResultConvertible], where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil)
        -> Single<FundamentalRow> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getRow(on: columnResultConvertibleList, where: condition, orderBy: orderList, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getRow(on columnResultConvertibleList: ColumnResultConvertible..., where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, offset: Offset? = nil) -> Single<FundamentalRow> {
        return getRow(on: columnResultConvertibleList, where: condition, orderBy: orderList, offset: offset)
    }

    func getColumn(on result: ColumnResultConvertible, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalColumn> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getColumn(on: result, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getDistinctColumn(on result: ColumnResultConvertible, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalColumn> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getDistinctColumn(on: result, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getValue(on result: ColumnResultConvertible, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalValue> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getValue(on: result, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }

    func getDistinctValue(on result: ColumnResultConvertible, where condition: Condition? = nil, orderBy orderList: [OrderBy]? = nil, limit: Limit? = nil, offset: Offset? = nil) -> Single<FundamentalValue> {
        return Single.create { observer -> Disposable in
            do {
                observer(.success(try self.base.getDistinctValue(on: result, where: condition, orderBy: orderList, limit: limit, offset: offset)))
            } catch {
                observer(.error(error))
            }
            return Disposables.create {}
        }
    }
}
