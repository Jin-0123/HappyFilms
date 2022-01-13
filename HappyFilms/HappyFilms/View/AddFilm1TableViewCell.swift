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
    
    var item: Film? {
        switch self {
        case .select(let item): return item
        default: return nil
        }
    }
}

class AddFilm1TableViewCell: BindingEventCell<AddFilm1CellEvent> {

    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    var item: Film?
    
    func set(_ item: Film) {
        self.item = item
        
        var description: String {
            let pubDate = "개봉일자: \(item.pubDate)"
            let userRating = item.userRating.isEmpty ? "" : " | 평점: \(item.userRating)"
            return pubDate + userRating
        }
        
        titleLabel.text = item.title.htmlToString
        descriptionLabel.text = description.htmlToString
        checkLabel.isHidden = !item.isSelected
    }
    
    override func getEvent(event: AddFilm1CellEvent) -> Observable<AddFilm1CellEvent>? {
        return containerButton.rx.tap.map { [weak self] in
            guard let self = self else { return .ignore }
            return .select(self.item)
        }
    }
}
