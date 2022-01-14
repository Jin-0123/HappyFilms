//
//  FilmListTableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit
import RxSwift
import RxCocoa

enum FilmListCellEvent: CaseIterable {
    case ignore
    case selected(Film?)
    
    static var allCases: [FilmListCellEvent] = [.selected(nil)]
    
    var film: (Film)? {
        switch self {
        case .selected(let film): return film
        default: return nil
        }
    }
}

class FilmListTableViewCell: BindingEventCell<FilmListCellEvent> {
    
    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var film: Film?
    
    func set(_ film: Film) {
        self.film = film
        
        titleLabel.text = film.prettyTitle
        dateLabel.text = film.watchedDateString
        likeButton.setTitle(film.isLiked ? "❤️" : "🤍", for: .normal)
    }
    
    override func getEvent(event: FilmListCellEvent) -> Observable<FilmListCellEvent>? {
        containerButton.rx.tap.map { [weak self] in
            guard let self = self, let film = self.film else { return .ignore }
            return .selected(film)
        }
    }
}
