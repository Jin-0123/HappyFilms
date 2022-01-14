//
//  FilmLocal.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 14/1/22.
//

import Foundation
import RealmSwift

class FilmLocal: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var director: String = ""
    @objc dynamic var actor: String = ""
    @objc dynamic var pubDate: String = ""
    @objc dynamic var userRating: String = ""
    @objc dynamic var isSelected: Bool = false
    @objc dynamic var isLiked: Bool = false
    @objc dynamic var saveDate: Date?
    @objc dynamic var watchedDate: Date?
    @objc dynamic var memo: String?
    
    convenience init(id: String, title: String, image: String, director: String, actor: String, pubDate: String, userRating: String, isSelected: Bool = false, isLiked: Bool = false, saveDate: Date? = nil, watchedDate: Date? = nil, memo: String? = nil) {
        self.init()
        
        self.id = id
        self.title = title
        self.image = image
        self.director = director
        self.actor = actor
        self.pubDate = pubDate
        self.userRating = userRating
        self.isSelected = isSelected
        self.isLiked = isLiked
        self.saveDate = saveDate
        self.watchedDate = watchedDate
        self.memo = memo
    }
    
    public override class func primaryKey() -> String? {
        "id"
    }
}
