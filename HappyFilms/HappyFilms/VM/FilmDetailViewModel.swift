//
//  FilmDetailViewModel.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 14/1/22.
//

import Foundation
import RxCocoa
import RxSwift

class FilmDetailViewModel: ViewModelType {
        
    enum Actions {
        case ignore
    }
    
    struct Inputs {
        let tapLikeButton: Observable<Void>
    }
    
    struct State: ActionState, ErrorState {
        let action: PublishRelay<Actions>
        let error: PublishRelay<Error>
    }
    
    struct Outputs: HasAction, HasError {
        let film: Driver<Film>
        let action: Driver<Actions>
        let error: Driver<Error>
    }
    
    let state: State
    let outputs: Outputs
    
    private let hfInteractor: HFInteractor!
    private let filmsManager: FilmsManager!
    private let disposeBag = DisposeBag()
    private var filmRelay: BehaviorRelay<Film?> = BehaviorRelay(value: nil)
    
    init(hfInteractor: HFInteractor, filmsManager: FilmsManager) {
        self.hfInteractor = hfInteractor
        self.filmsManager = filmsManager
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        outputs = Outputs(film: filmRelay.unwrap().asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
    }
    
    func setup(_ film: Film) {
        filmRelay.accept(film)
    }
    
    func bind(_ inputs: Inputs) {
        inputs.tapLikeButton
            .do(onNext: { [weak self] in
                guard let self = self, let film = self.filmRelay.value else { return }
                var copied = film
                copied.isLiked = !film.isLiked
                self.filmRelay.accept(copied)
                self.filmsManager.update(copied)
            })
            .map { .ignore }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
