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
        case ignore
        case showAddFilm1
        case showDetail(Film)
        case showSortSheet
        case selectedSortOption(SortOption)
    }
    
    struct Inputs {
        let tapFilm: Observable<Film>
        let tapAdd: Observable<Void>
        let tapSortButton: Observable<Void>
        let selectSortOption: Observable<SortOption?>
    }
    
    struct State: ActionState, ErrorState {
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
    private let filmsManager: FilmsManager!
    private let disposeBag = DisposeBag()
    var sortOption: SortOption {
        return filmsManager.sortOption
    }
    
    init(hfInteractor: HFInteractor, filmsManager: FilmsManager) {
        self.hfInteractor = hfInteractor
        self.filmsManager = filmsManager
        
        state = State(action: PublishRelay(),
                      error: PublishRelay())
        
        let sortedFilms = Observable.combineLatest(filmsManager.get(), filmsManager.sortOptionRelay)
            .map { films, sortOption -> [Film] in
                let now = Date()
                return films.sorted {
                    switch sortOption {
                    case .saveDate:
                        return $0.saveDate ?? now < $1.saveDate ?? now
                    case .watchedDate:
                        return $0.watchedDate ?? now < $1.watchedDate ?? now
                    case .pubDate:
                        return $0.pubDate < $1.pubDate
                    }
                }
            }
        
        outputs = Outputs(films: sortedFilms.asDriver(onErrorDriveWith: .empty()),
                          action: state.action.asDriver(onErrorDriveWith: .empty()),
                          error: state.error.asDriver(onErrorDriveWith: .empty()))
                
    }
    
    func bind(_ inputs: Inputs) {
        inputs.tapAdd
            .map { .showAddFilm1 }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.tapFilm
            .map { .showDetail($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.tapSortButton
            .map { .showSortSheet }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        inputs.selectSortOption
            .do(onNext: { [weak self] option in
                guard let option = option else { return }
                self?.filmsManager.selectSortOption(option)
            })
            .map { _ in .ignore }
            .bind(to: state.action)
            .disposed(by: disposeBag)
        
        filmsManager.sortOptionRelay
            .map { .selectedSortOption($0) }
            .bind(to: state.action)
            .disposed(by: disposeBag)
    }
}
