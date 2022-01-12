//
//  HFInterface.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxSwift

protocol HFInterface {
    
    func getGenres() -> [Genre]?
    func setGenres(_ genres: [Genre])
}
