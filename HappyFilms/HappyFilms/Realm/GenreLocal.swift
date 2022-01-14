//
//  GenreLocal.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 14/1/22.
//

import Foundation
import RealmSwift

class GenreLocal: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var isOn: Bool = true
    @objc dynamic var saveDate: Date?
    
    convenience init(id: String, title: String, isOn: Bool, saveDate: Date? = nil) {
        self.init()
        
        self.id = id
        self.title = title
        self.isOn = isOn
        self.saveDate = saveDate
    }
    
    public override class func primaryKey() -> String? {
        "id"
    }
}
