//
//  AddFilm1ViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class AddFilm1ViewModel: ViewModelType {
        
    enum Actions {
        case ignore
        case showAddFilm2(Film)
        case isActivateNext(Bool)
    }
    
    struct Inputs {
        let tapNext: Observable<Void>
        let keyword: Observable<String>
        let select: Observable<Film?>
    }
    
    struct State: ActionState, ErrorState {
        let data: BehaviorRelay<[Film]?>
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
        let films: Driver<[Film]>
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    private let hfInteractor: HFInteractor!
    private let disposeBag = DisposeBag()
    
    init(hfInteractor: HFInteractor) {
        self.hfInteractor = hfInteractor
        
        state = State(data: BehaviorRelay(value: []),
                      action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(films: state.data.unwrap().asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
                
    }
    
    func bind(_ inputs: Inputs) {
        let selectedFilmRelay: BehaviorRelay<Film?> = BehaviorRelay(value: nil)
        
        inputs.tapNext
            .map {
                if let selected = selectedFilmRelay.value {
                    return .showAddFilm2(selected)
                } else {
                    return .ignore
                }
            }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
       inputs.keyword
            .filter { !$0.isEmpty }
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .do(onNext: { _ in
                selectedFilmRelay.accept(nil)
            })
            .flatMapLatest { [weak self] in
                self?.hfInteractor.searchFilms($0) ?? .empty()
            }
            .bind(to: state.data)
            .disposed(by: disposeBag)
        
        inputs.select
            .do(onNext: { [weak self] selected in
                guard let self = self, var copiedList = self.state.data.value else { return }
                
                for (index, copied) in copiedList.enumerated() {
                    copiedList[index].isSelected = copied == selected
                }
                
                selectedFilmRelay.accept(selected)
                self.state.data.accept(copiedList)
            })
            .map { _ in .ignore }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        selectedFilmRelay
            .map { .isActivateNext($0 != nil) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
