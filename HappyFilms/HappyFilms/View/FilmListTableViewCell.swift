//
//  FilmListTableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import UIKit

class FilmListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func set(_ film: Film) {
        titleLabel.text = film.prettyTitle
        dateLabel.text = film.watchedDateString
        likeButton.setTitle(film.isLiked ? "❤️" : "🤍", for: .normal)
    }
}
