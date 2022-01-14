//
//  HFInterface.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxSwift

protocol HFInterface {
    
    func getGenres() -> [Genre]
    func addGenre(_ genre: Genre)
    func updateGenre(id: String, isOn: Bool)
    
    func searchFilms(_ keyword: String) -> Observable<[Film]?>
}
