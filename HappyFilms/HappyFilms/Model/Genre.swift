//
//  Genre.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 12/1/22.
//

import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt

struct Genre: Equatable {
    let id: UUID
    let title: String
    var isOn: Bool
    var saveDate: Date?
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
}

class GenresManager {
    
    static let shared: GenresManager = GenresManager()
    
    private init() { }
    
    var genresRelay: BehaviorRelay<[Genre]> = BehaviorRelay(value: [])
    var genres: [Genre] {
        genresRelay.value
    }
    
    func fetch(_ genres: [Genre]?) {
        genresRelay.accept(genres ?? [])
    }
    
    func add(_ genre: Genre) {
        var cached = genresRelay.value
        cached.append(genre)
        genresRelay.accept(cached)
    }
    
    func toggle(_ id: UUID, isOn: Bool) {
        var cached = genresRelay.value
        if let index = cached.firstIndex(where: { $0.id == id }) {
            cached[index].isOn = isOn
            genresRelay.accept(cached)
        }
    }
}
