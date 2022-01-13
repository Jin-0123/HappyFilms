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
        let changedWatchedDate: Observable<Date>
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
    private let filmsManager: FilmsManager!
    private let disposeBag = DisposeBag()
    private var copiedFilm: Film?
    
    init(hfInteractor: HFInteractor, filmsManager: FilmsManager) {
        self.hfInteractor = hfInteractor
        self.filmsManager = filmsManager
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
    }
    
    func setup(_ film: Film) {
        copiedFilm = film
    }
    
    func bind(_ inputs: Inputs) {
        let watchedDateRelay: BehaviorRelay<Date?> = BehaviorRelay(value: nil)
        
        inputs.tapDateButton
            .map { .showPicker }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.tapDone
            .flatMapLatest {
                inputs.memo.debug()
            }
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] memo in
                guard let self = self, var copiedFilm = self.copiedFilm else { return }
                copiedFilm.saveDate = Date()
                copiedFilm.watchedDate = watchedDateRelay.value
                copiedFilm.memo = memo
                self.filmsManager.add(copiedFilm)
            })
            .map { _ in .popToFilmList }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.changedWatchedDate
            .do(onNext: {
                watchedDateRelay.accept($0)
            })
            .map { .changeDate($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.memo
            .map { .isActivateDone($0 != "" && (watchedDateRelay.value ?? nil) != nil) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
