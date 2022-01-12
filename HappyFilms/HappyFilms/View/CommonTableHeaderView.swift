//
//  CommonTableHeaderView.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation
import UIKit

class CommonTableHeaderView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.contentHorizontalAlignment = .trailing
        button.isHidden = true
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
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
                
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 80),
            addButton.heightAnchor.constraint(equalToConstant: 80),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
    func set(_ title: String, useAddButton: Bool = false) {
        titleLabel.text = title
        
        if useAddButton {
            addButton.isHidden = false
        }
    }
}
