//
//  HFInteractor.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxSwift

class HFInteractor {
    
    private let interface: HFInterface
    
    init(interface: HFInterface) {
        self.interface = interface
    }
    
    func getGenres() -> [Genre] {
        interface.getGenres()
    }
    
    func addGenre(_ genre: Genre) {
        interface.addGenre(genre)
    }
    
    func updateGenre(id: String, isOn: Bool) {
        interface.updateGenre(id: id, isOn: isOn)
    }
    
    func searchFilms(_ keyword: String) -> Observable<[Film]?> {
        interface.searchFilms(keyword)
    }
}
