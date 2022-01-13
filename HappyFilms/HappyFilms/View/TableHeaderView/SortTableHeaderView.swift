//
//  SortTableHeaderView.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import UIKit

class SortTableHeaderView: UIView {
   
    let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .leading
        button.setTitle("기록 생성 순 ▼", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setViews()
    }
    
    private func setViews() {
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
                
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleButton)
        
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    func set(_ title: String) {
        titleButton.setTitle("\(title) ⬇️", for: .normal)
    }
}
