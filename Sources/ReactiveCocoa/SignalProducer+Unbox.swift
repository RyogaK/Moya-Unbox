//
//  SignalProducer+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/13/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveMoya
import Unbox

public extension SignalProducerType where Value == Response, Error == Error {
    public func mapObject<T: Unboxable>(type: T.Type) -> SignalProducer<T, Error> {
        return producer.flatMap(.Latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.mapObject(T) }
        }
    }
    
    public func mapArray<T: Unboxable>(type: T.Type) -> SignalProducer<[T], Error> {
        return producer.flatMap(.Latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.mapArray(T) }
        }
    }
}

private func unwrapThrowable<T, Error>(throwable: () throws -> T) -> SignalProducer<T, Error> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! Error)
    }
}

public extension Response {
    public func mapObject<T: Unboxable>(type: T.Type) throws -> T {
        guard let json = try mapJSON() as? UnboxableDictionary else {
            throw Error.JSONMapping(self)
        }
        return try Unbox(json)
    }
    
    public func mapArray<T: Unboxable>(type: T.Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [UnboxableDictionary] else {
            throw Error.JSONMapping(self)
        }
        return try Unbox(jsonArray)
    }
}
