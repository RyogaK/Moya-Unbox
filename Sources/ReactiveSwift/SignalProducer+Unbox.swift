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
    public func unbox<T: Unboxable>(object: T.Type) -> SignalProducer<T, Error> {
        return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.unbox(object: T.self) }
        }
    }
    
    public func unbox<T: Unboxable>(array: T.Type) -> SignalProducer<[T], Error> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.unbox(array: T.self) }
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
