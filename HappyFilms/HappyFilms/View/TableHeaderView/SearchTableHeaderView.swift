//
//  SearchTableHeaderView.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 13/1/22.
//

import Foundation
import UIKit

class SearchTableHeaderView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "🔎 영화 이름이 무엇인가요?"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.becomeFirstResponder()
        return textField
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
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 112)
                
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textField)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            textField.heightAnchor.constraint(equalToConstant: 44),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
}
