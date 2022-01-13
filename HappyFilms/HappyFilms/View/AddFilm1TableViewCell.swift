//
//  AddFilm1TableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit
import RxSwift
import RxCocoa

enum AddFilm1CellEvent: CaseIterable {
    case ignore
    case select(Film?)
    
    static var allCases: [AddFilm1CellEvent] = [.select(nil)]
    
    var film: Film? {
        switch self {
        case .select(let film): return film
        default: return nil
        }
    }
}

class AddFilm1TableViewCell: BindingEventCell<AddFilm1CellEvent> {

    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    var film: Film?
    
    func set(_ film: Film) {
        self.film = film
        
        var description: String {
            let pubDate = "개봉일자: \(film.pubDate)"
            let userRating = film.userRating.isEmpty ? "" : " | 평점: \(film.userRating)"
            return pubDate + userRating
        }
        
        titleLabel.text = film.prettyTitle
        descriptionLabel.text = description.htmlToString
        checkLabel.isHidden = !film.isSelected
    }
    
    override func getEvent(event: AddFilm1CellEvent) -> Observable<AddFilm1CellEvent>? {
        return containerButton.rx.tap.map { [weak self] in
            guard let self = self else { return .ignore }
            return .select(self.film)
        }
    }
}
