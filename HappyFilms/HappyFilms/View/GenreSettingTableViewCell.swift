//
//  GenreSettingTableViewCell.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import UIKit
import RxSwift
import RxCocoa

enum GenreSettingCellEvent: CaseIterable {
    case ignore
    case toggle((UUID, Bool))
    
    static var allCases: [GenreSettingCellEvent] = [.toggle((UUID(), true))]
    
    var info: (UUID, Bool)? {
        switch self {
        case .toggle((let id, let isOn)): return (id, isOn)
        default: return nil
        }
    }
}

class GenreSettingTableViewCell: BindingEventCell<GenreSettingCellEvent> {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreSwitch: UISwitch!
    
    let disposeBag = DisposeBag()
    private var id: UUID?
   
    func set(_ id: UUID, title: String, isOn: Bool) {
        self.id = id
        
        titleLabel.text = title
        genreSwitch.isOn = isOn
    }
    
    override func getEvent(event: GenreSettingCellEvent) -> Observable<GenreSettingCellEvent>? {
        genreSwitch.rx.controlEvent(.valueChanged).map { [weak self] in
            guard let self = self, let id = self.id else { return .ignore }
            return .toggle((id, self.genreSwitch.isOn))
        }
    }
}
