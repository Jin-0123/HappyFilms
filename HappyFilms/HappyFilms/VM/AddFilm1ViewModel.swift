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
        case showAddFilm2
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
        inputs.tapNext
            .map { .showAddFilm2 }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
       inputs.keyword
            .filter { !$0.isEmpty }
            .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] in
                self?.hfInteractor.searchFilms($0) ?? .empty()
            }
            .bind(to: state.data)
            .disposed(by: disposeBag)
        
        inputs.select
            .do(onNext: { [weak self] selected in
                guard let self = self, var copiedList = self.state.data.value else { return }
               
                if let selectedIndex = copiedList.firstIndex(where: { $0 == selected }) {
                    for (index, _) in copiedList.enumerated() {
                        copiedList[index].isSelected = index == selectedIndex ? true : false
                    }
                }
                self.state.data.accept(copiedList)
            })
            .map { _ in .ignore }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        state.data
            .map {
                let isActivate = $0?.first(where: { $0.isSelected == true }) == nil ? false : true
                return .isActivateNext(isActivate)
            }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
