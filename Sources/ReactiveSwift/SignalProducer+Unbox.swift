//
//  SignalProducer+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/13/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveMoya
import Moya
import Unbox

public extension SignalProducerProtocol where Value == Response, Error == Error {
    public func mapObject<T: Unboxable>(_ type: T.Type) -> SignalProducer<T, Error> {
        return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.mapObject(T.self) }
        }
    }
    
    public func mapArray<T: Unboxable>(_ type: T.Type) -> SignalProducer<[T], Error> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.mapArray(T.self) }
        }
    }
}

private func unwrapThrowable<T, Error>(_ throwable: () throws -> T) -> SignalProducer<T, Error> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! Error)
    }
}

public extension Response {
    public func mapObject<T: Unboxable>(_ type: T.Type) throws -> T {
        guard let json = try mapJSON() as? UnboxableDictionary else {
            throw Error.jsonMapping(self)
        }
        return try unbox(dictionary: json)
    }
    
    public func mapArray<T: Unboxable>(_ type: T.Type) throws -> [T] {
        guard let jsonArray = try mapJSON() as? [UnboxableDictionary] else {
            throw Error.jsonMapping(self)
        }
        return try unbox(dictionaries: jsonArray)
    }
}
