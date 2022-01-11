//
//  MyFilmsNoteTableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import UIKit

class MyFilmsNoteTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    func set(_ text: String) {
        title.text = text
    }
}
