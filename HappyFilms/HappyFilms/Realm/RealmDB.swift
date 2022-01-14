//
//  RealmDB.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 14/1/22.
//

import Foundation
import RealmSwift
import RxSwift
import RxSwiftExt

class RealmDB {
    
    static let shared = RealmDB()
    
    private var localRealm: Realm? = try? Realm()
    
    func genres() -> [GenreLocal] {
        guard let realm = RealmDB.shared.localRealm else { return [] }

        let now = Date()
        return realm.objects(GenreLocal.self).sorted(by: { $0.saveDate ?? now < $1.saveDate ?? now})
    }
    
    func addGenre(id: String, title: String, isOn: Bool, saveDate: Date? = nil) {
        guard let realm = RealmDB.shared.localRealm else { return  }
        
        let local = GenreLocal(id: id, title: title, isOn: isOn, saveDate: saveDate)
        
        let _ = try? realm.write {
            realm.create(GenreLocal.self, value: local, update: .all)
        }
    }
    
    func updateGenre(id: String, isOn: Bool) {
        guard let realm = RealmDB.shared.localRealm else { return  }
        
        if let genre = realm.objects(GenreLocal.self).filter({ $0.id == id }).first {
            try! realm.write { genre.isOn = isOn }
        }
    }
}
