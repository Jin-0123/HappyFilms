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
    case selected(UUID)
    
    static var allCases: [MyFilmsNoteCellEvent] = [.selected(UUID())]
    
    var id: (UUID)? {
        switch self {
        case .selected(let id): return (id)
        default: return nil
        }
    }
}

class MyFilmsNoteTableViewCell: BindingEventCell<MyFilmsNoteCellEvent> {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerButton: UIButton!
    
    private var id: UUID?
    
    func set(_ id: UUID, title: String) {
        self.id = id
        
        titleLabel.text = title
    }
    
    override func getEvent(event: MyFilmsNoteCellEvent) -> Observable<MyFilmsNoteCellEvent>? {
        containerButton.rx.tap.map { [weak self] in
            guard let self = self, let id = self.id else { return .ignore }
            return .selected(id)
        }
    }
    
}
