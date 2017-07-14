//
//  SwiftExtension.swift
//  CityParty
//
//  Created by hcy on 16/4/4.
//  Copyright © 2015年 hcy. All rights reserved.
//

import Foundation
import UIKit
import FMDB

extension FMDatabase {
    
    fileprivate func valueForQuery<T>(_ sql: String, values: [AnyObject]?, completionHandler:(FMResultSet)->(T!)) -> T! {
        var result: T!
        
        if let rs = executeQuery(sql, withArgumentsIn: values) {
            if rs.next() {
                let obj: AnyObject! = rs.object(forColumnIndex: 0) as AnyObject!
                if !(obj is NSNull) {
                    result = completionHandler(rs)
                }
            }
            rs.close()
        }
        
        return result
    }
    
    
    func stringForQuery(_ sql: String, _ values: AnyObject...) -> String! {
        return valueForQuery(sql, values: values) { $0.string(forColumnIndex: 0) }
    }
    
    
    func intForQuery(_ sql: String, _ values: AnyObject...) -> Int32! {
        return valueForQuery(sql, values: values) { $0.int(forColumnIndex: 0) }
    }
    
    func longForQuery(_ sql: String, _ values: AnyObject...) -> Int! {
        return valueForQuery(sql, values: values) { $0.long(forColumnIndex: 0) }
    }
    
    func boolForQuery(_ sql: String, _ values: AnyObject...) -> Bool! {
        return valueForQuery(sql, values: values) { $0.bool(forColumnIndex: 0) }
    }
    
    func doubleForQuery(_ sql: String, _ values: AnyObject...) -> Double! {
        return valueForQuery(sql, values: values) { $0.double(forColumnIndex: 0) }
    }
    
    func dateForQuery(_ sql: String, _ values: AnyObject...) -> Date! {
        return valueForQuery(sql, values: values) { $0.date(forColumnIndex: 0) }
    }
    
    func dataForQuery(_ sql: String, _ values: AnyObject...) -> Data! {
        return valueForQuery(sql, values: values) { $0.data(forColumnIndex: 0) }
    }
    
    func executeQuery(_ sql:String, _ values: [AnyObject]?) -> FMResultSet? {
        return executeQuery(sql, withArgumentsIn: values as [AnyObject]?);
    }
    
    func executeUpdate(_ sql:String, _ values: [AnyObject]?) -> Bool {
        return executeUpdate(sql, withArgumentsIn: values as [AnyObject]?);
    }
    
}


                                            
