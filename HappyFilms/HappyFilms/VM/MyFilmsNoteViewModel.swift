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
        
    enum Actions {
        case ignore
        case showFilmsList(Genre)
    }
    
    struct Inputs {
        let tapGenre: Observable<Genre>
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
    private let filmsManager: FilmsManager!
    private let disposeBag = DisposeBag()
    
    init(hfInteractor: HFInteractor, genresManager: GenresManager, filmsManager: FilmsManager) {
        self.hfInteractor = hfInteractor
        self.genresManager = genresManager
        self.filmsManager = filmsManager
        
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
    
    func bind(_ inputs: Inputs) {
        inputs.tapGenre
            .do(onNext: { [weak self] in
                self?.filmsManager.selectGenre($0.id)
            })
            .map { .showFilmsList($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
