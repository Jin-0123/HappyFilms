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
    
    func getGenres() -> [Genre]? {
        interface.getGenres()
    }
    
    func setGenres(_ genres: [Genre]) {
        interface.setGenres(genres)
    }
}
