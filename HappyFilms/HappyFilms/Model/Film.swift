//
//  Film.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation

struct Film: Equatable {
    let title: String
    let image: String
    let director: String
    let actor: String
    let pubDate: String
    let userRating: String
    var isSelected: Bool
    var watchedDate: Date?
    var memo: String?
    
    init(from dto: FilmItemDTO) {
        title = dto.title
        image = dto.image
        director = dto.director
        actor = dto.actor
        pubDate = dto.pubDate
        userRating = dto.userRating
        isSelected = false
    }
    
    static func == (lhs: Film, rhs: Film) -> Bool {
        return lhs.title == rhs.title &&
        lhs.image == rhs.image &&
        lhs.director == rhs.director &&
        lhs.actor == rhs.actor &&
        lhs.pubDate == rhs.pubDate &&
        lhs.userRating == rhs.userRating
    }
}
