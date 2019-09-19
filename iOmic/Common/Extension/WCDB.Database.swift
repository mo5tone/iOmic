//
//  WCDB.Database.swift
//  iOmic
//
//  Created by Jeff Men (CN) on 2019/9/19.
//  Copyright © 2019 门捷夫. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

/*
 extension Database : InsertChainCallInterface { }

 extension Database : UpdateChainCallInterface { }

 extension Database : DeleteChainCallInterface { }

 extension Database : RowSelectChainCallInterface { }

 extension Database : SelectChainCallInterface { }

 extension Database : MultiSelectChainCallInterface { }

 extension Database : InsertInterface { }

 extension Database : UpdateInterface { }

 extension Database : DeleteInterface { }

 extension Database : RowSelectInterface { }

 extension Database : SelectInterface { }

 extension Database : TableInterface { }
 */

extension Database: ReactiveCompatible {}

// MARK: - TableInterface

extension Reactive where Base: TableInterface {
    func create<Root>(virtualTable name: String, of rootType: Root.Type) -> Completable where Root: TableDecodable {
        return Completable.create {
            do {
                try self.base.create(virtualTable: name, of: rootType)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create<Root>(table name: String, of rootType: Root.Type) -> Completable where Root: TableDecodable {
        return Completable.create {
            do {
                try self.base.create(table: name, of: rootType)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(table name: String, with columnDefList: [ColumnDef], and constraintList: [TableConstraint]? = nil) -> Completable {
        return Completable.create {
            do {
                try self.base.create(table: name, with: columnDefList, and: constraintList)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(table name: String, with columnDefList: ColumnDef..., and constraintList: [TableConstraint]? = nil) -> Completable {
        return create(table: name, with: columnDefList, and: constraintList)
    }

    func addColumn(with columnDef: ColumnDef, forTable table: String) -> Completable {
        return Completable.create {
            do {
                try self.base.addColumn(with: columnDef, forTable: table)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func drop(table name: String) -> Completable {
        return Completable.create {
            do {
                try self.base.drop(table: name)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(index name: String, with columnIndexConvertibleList: [ColumnIndexConvertible], forTable table: String) -> Completable {
        return Completable.create {
            do {
                try self.base.create(index: name, with: columnIndexConvertibleList, forTable: table)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }

    func create(index name: String, with columnIndexConvertibleList: ColumnIndexConvertible..., forTable table: String) -> Completable {
        return create(index: name, with: columnIndexConvertibleList, forTable: table)
    }

    func drop(index name: String) -> Completable {
        return Completable.create {
            do {
                try self.base.drop(index: name)
                $0(.completed)
            } catch {
                $0(.error(error))
            }
            return Disposables.create {}
        }
    }
}

// MARK: - SelectInterface

extension Reactive where Base: SelectInterface {}
