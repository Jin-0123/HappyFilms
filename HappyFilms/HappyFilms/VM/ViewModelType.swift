//
//  ViewModelType.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import RxCocoa

protocol ViewModelType {
    
    associatedtype Inputs
    associatedtype State: ActionState, ErrorState
    associatedtype Outputs: HasAction, HasError

    var state: State { get }
    var outputs: Outputs { get }

    func bind(_ inputs: Inputs)
}

protocol ActionState {

    associatedtype Action

    var action: PublishRelay<Action> { get }
}

protocol ErrorState {
    
    var error: PublishRelay<Error> { get }
}

protocol HasAction {

    associatedtype Action

    var action: Driver<Action> { get }
}

protocol HasError {
    
    var error: Driver<Error> { get }
}

