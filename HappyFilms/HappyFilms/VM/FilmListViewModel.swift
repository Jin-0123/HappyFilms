//
//  FilmListViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class FilmListViewModel: ViewModelType {
        
    enum Actions {
        case showAddFilm1
    }
    
    struct Inputs {
        let tapAdd: Observable<Void>
    }
    
    struct State: ActionState, ErrorState {
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
//        let genres: Driver<[Genre]>
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    private let hfInteractor: HFInteractor!
    private let disposeBag = DisposeBag()
    
    init(hfInteractor: HFInteractor) {
        self.hfInteractor = hfInteractor
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
                
    }
    
    func bind(_ inputs: Inputs) {
        inputs.tapAdd
            .map { .showAddFilm1 }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
