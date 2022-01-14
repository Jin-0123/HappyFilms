//
//  MyFilmsNoteTableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import UIKit
import RxSwift
import RxCocoa

enum MyFilmsNoteCellEvent: CaseIterable {
    case ignore
    case selected(Genre?)
    
    static var allCases: [MyFilmsNoteCellEvent] = [.selected(nil)]
    
    var genre: (Genre)? {
        switch self {
        case .selected(let genre): return genre
        default: return nil
        }
    }
}

class MyFilmsNoteTableViewCell: BindingEventCell<MyFilmsNoteCellEvent> {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerButton: UIButton!
    
    private var genre: Genre?
    
    func set(_ genre: Genre) {
        self.genre = genre
        
        titleLabel.text = genre.title
    }
    
    override func getEvent(event: MyFilmsNoteCellEvent) -> Observable<MyFilmsNoteCellEvent>? {
        containerButton.rx.tap.map { [weak self] in
            guard let self = self, let genre = self.genre else { return .ignore }
            return .selected(genre)
        }
    }
}
