//
//  MyFilmsNoteViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class MyFilmsNoteViewModel: ViewModelType {
    
    // MARK: - implement ViewModelType
    
    enum Actions {
        case showFilmsList(Int)
    }
    
    struct Inputs {
        let tapGenre: Observable<IndexPath>
    }
    
    struct State: ActionState, ErrorState {
        let items: BehaviorRelay<[String]?>
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
        let genres: Driver<[String]>
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    func bind(_ inputs: Inputs) {
        inputs.tapGenre
            .map { .showFilmsList($0.row) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    
    private let disposeBag = DisposeBag()
    
    init() {
        state = State(items: BehaviorRelay(value: nil),
                      action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(genres: state.items.unwrap().asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
        
        // TODO: - 장르 정보 수정 필요
        self.setup()
    }
    
    func setup() {
        Observable.just(["로맨스", "스릴러", "액션"])
            .bind(to: state.items)
            .disposed(by: disposeBag)
    }
}
