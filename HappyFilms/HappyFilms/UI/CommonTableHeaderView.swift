//
//  CommonTableHeaderView.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import UIKit

class CommonTableHeaderView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
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
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
