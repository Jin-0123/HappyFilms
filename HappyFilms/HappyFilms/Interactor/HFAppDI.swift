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

    var myFilmsNoteViewModel: MyFilmsNoteViewModel {
        MyFilmsNoteViewModel(hfInteractor: interactor, genresManager: genresManager)
    }
    
    var genreSettingViewModel: GenreSettingViewModel {
        GenreSettingViewModel(hfInteractor: interactor, genresManager: genresManager)
    }
    
}
