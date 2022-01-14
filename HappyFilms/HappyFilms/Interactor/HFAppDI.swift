//
//  HFAppDI.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation

class HFAppDI {
    static let shared: HFAppDI = HFAppDI()
    
    private init() { }
    
    lazy var interactor: HFInteractor = HFInteractor(interface: HFRepo())
    lazy var genresManager: GenresManager = GenresManager.shared
    lazy var filmsManager: FilmsManager = FilmsManager.shared

    var myFilmsNoteViewModel: MyFilmsNoteViewModel {
        MyFilmsNoteViewModel(hfInteractor: interactor, genresManager: genresManager, filmsManager: filmsManager)
    }
    
    var genreSettingViewModel: GenreSettingViewModel {
        GenreSettingViewModel(hfInteractor: interactor, genresManager: genresManager)
    }
    
    var filmListViewModel: FilmListViewModel {
        FilmListViewModel(hfInteractor: interactor, filmsManager: filmsManager)
    }
    
    var filmDetailViewModel: FilmDetailViewModel {
        FilmDetailViewModel(hfInteractor: interactor, filmsManager: filmsManager)
    }
    
    var addFilm1ViewModel: AddFilm1ViewModel {
        AddFilm1ViewModel(hfInteractor: interactor)
    }
    
    var addFilm2ViewModel: AddFilm2ViewModel {
        AddFilm2ViewModel(hfInteractor: interactor, filmsManager: filmsManager)
    }
}
