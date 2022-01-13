//
//  FilmsDTO.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation

struct FilmsDTO: Decodable {
    let items: [FilmItemDTO]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        items = try values.decode([FilmItemDTO].self, forKey: .items)
    }
    
    private enum CodingKeys : String, CodingKey {
        case items
    }
}

struct FilmItemDTO: Decodable {
    let title: String
    let image: String
    let director: String
    let actor: String
    let pubDate: String
    let userRating: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        image = try values.decode(String.self, forKey: .image)
        director = try values.decode(String.self, forKey: .director)
        actor = try values.decode(String.self, forKey: .actor)
        pubDate = try values.decode(String.self, forKey: .pubDate)
        userRating = try values.decode(String.self, forKey: .userRating)
    }
    
    private enum CodingKeys : String, CodingKey {
        case title, image, director, actor, pubDate, userRating
    }
}
