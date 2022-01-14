//
//  HFRepo.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxSwift

class HFRepo: HFInterface {

    func getGenres() -> [Genre] {
        RealmDB.shared.genres().compactMap { $0.toModel }
    }
    
    func addGenre(_ genre: Genre) {
        RealmDB.shared.addGenre(id: genre.id.uuidString, title: genre.title, isOn: genre.isOn, saveDate: genre.saveDate)
    }
    
    func updateGenre(id: String, isOn: Bool) {
        RealmDB.shared.updateGenre(id: id, isOn: isOn)
    }
    
    func searchFilms(_ keyword: String) -> Observable<[Film]?> {
        NaverSearchAPI.searchFilms(keyword).map {
            $0?.items.map { Film(from: $0) }
        }
    }
}

fileprivate extension GenreLocal {
    var toModel: Genre? {
        guard let uuid = UUID(uuidString: id) else { return nil }
        return Genre(id: uuid, title: title, isOn: isOn, saveDate: saveDate)
    }
}
