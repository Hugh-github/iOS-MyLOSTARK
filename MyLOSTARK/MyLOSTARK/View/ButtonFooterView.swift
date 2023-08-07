//
//  ButtonFooterView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

import UIKit

class ButtonFooterView: UICollectionReusableView {
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        self.button.setTitle(title, for: .normal)
    }
    
    private func setLayout() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
}
