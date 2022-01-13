//
//  HFRepo.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxSwift

class HFRepo: HFInterface {
    
    func getGenres() -> [Genre]? {
        nil
    }
    
    func setGenres(_ genres: [Genre]) {
        
    }
    
    func searchFilms(_ keyword: String) -> Observable<[Film]?> {
        NaverSearchAPI.searchFilms(keyword).map {
            $0?.items.map { Film.init(from: $0) }
        }
    }
}
