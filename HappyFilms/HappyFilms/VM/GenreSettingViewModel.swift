//
//  GenreSettingViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

class GenreSettingViewModel: ViewModelType {
    
    enum Actions {
        case ignore
        case refresh
        case showAddAlert
    }
    
    struct Inputs {
        let tapAdd: Observable<Void>
        let tapAddConfirm: Observable<String>
        let toggle: Observable<(UUID, Bool)>
    }
    
    struct State: ActionState, ErrorState {
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
        let genres: Driver<[Genre]>
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    private let hfInteractor: HFInteractor!
    private let genresManager: GenresManager!
    private let disposeBag = DisposeBag()
    
    init(hfInteractor: HFInteractor, genresManager: GenresManager) {
        self.hfInteractor = hfInteractor
        self.genresManager = genresManager
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(genres: genresManager.genresRelay.asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
    }
    
    func bind(_ inputs: Inputs) {
        inputs.tapAdd
            .map { .showAddAlert }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.tapAddConfirm
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                let genre = Genre(id: UUID(), title: $0, isOn: true, saveDate: Date())
                self.genresManager.add(genre)
                self.hfInteractor.addGenre(genre)
            })
            .map { _ in .refresh }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.toggle
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                self.genresManager.toggle($0.0, isOn: $0.1)
                self.hfInteractor.updateGenre(id: $0.0.uuidString, isOn: $0.1)
            })
            .map { _ in .ignore }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
