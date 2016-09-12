//
//  Observable+Unbox.swift
//  Moya-Unbox
//
//  Created by Ryoga Kitagawa on 9/12/16.
//  Copyright © 2016 Ryoga Kitagawa. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Unbox

public extension ObservableType where E == Response {
    public func mapObject<T: Unboxable>(type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapObject(T))
        }
    }
    
    public func mapArray<T: Unboxable>(type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            return Observable.just(try response.mapArray(T))
        }
    }
}
