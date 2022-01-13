//
//  AddFilm2ViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import RxCocoa
import RxSwift

class AddFilm2ViewModel: ViewModelType {
        
    enum Actions {
        case ignore
        case popToFilmList
        case showPicker
        case changeDate(Date)
        case isActivateDone(Bool)
    }
    
    struct Inputs {
        let tapDateButton: Observable<Void>
        let tapDone: Observable<Void>
        let watchedDate: Observable<Date>
        let memo: Observable<String>
    }
    
    struct State: ActionState, ErrorState {
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    private let hfInteractor: HFInteractor!
    private let disposeBag = DisposeBag()
    private var copiedFilm: Film?
    
    init(hfInteractor: HFInteractor) {
        self.hfInteractor = hfInteractor
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
    }
    
    func setup(_ film: Film) {
        copiedFilm = film
    }
    
    func bind(_ inputs: Inputs) {
        inputs.tapDateButton
            .map { .showPicker }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.tapDone
            .map { .popToFilmList }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.watchedDate
            .map { .changeDate($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(inputs.watchedDate, inputs.memo)
            .map { .isActivateDone($1 != "") }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
