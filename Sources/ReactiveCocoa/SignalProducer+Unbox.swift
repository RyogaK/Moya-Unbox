//
//  SignalProducer+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/13/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Moya
import Unbox

public extension SignalProducerType where Value == Moya.Response, Error == Moya.Error {
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

private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, Moya.Error> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! Moya.Error)
    }
}
