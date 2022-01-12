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
        case showFilmsList(UUID)
    }
    
    struct Inputs {
        let tapGenre: Observable<UUID>
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
    
    func bind(_ inputs: Inputs) {
        inputs.tapGenre
            .map { .showFilmsList($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: -
    
    private let hfInteractor: HFInteractor!
    private let genresManager: GenresManager!
    
    private let disposeBag = DisposeBag()
    
    init(hfInteractor: HFInteractor, genresManager: GenresManager) {
        self.hfInteractor = hfInteractor
        self.genresManager = genresManager
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        genresManager.fetch(hfInteractor.getGenres())
        let genres = genresManager.genresRelay.map {
            $0.filter { $0.isOn }
        }
        
        outputs = Outputs(genres: genres.asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
                
    }
}
