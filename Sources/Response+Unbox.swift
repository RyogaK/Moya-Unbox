//
//  Response+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/12/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import Moya
import Unbox

public extension Response {
    public func unbox<T: Unboxable>(object: T.Type) throws -> T {
        guard let json = try mapJSON() as? UnboxableDictionary else {
            throw Error.jsonMapping(self)
        }
        return try Unbox.unbox(dictionary: json)
    }
    
    public func unbox<T: Unboxable>(array: T.Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [UnboxableDictionary] else {
            throw Error.jsonMapping(self)
        }
        return try Unbox.unbox(dictionaries: jsonArray)
    }
}
