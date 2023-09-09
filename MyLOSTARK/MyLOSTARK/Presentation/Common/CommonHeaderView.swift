//
//  CommonHeaderView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/20.
//

import UIKit

class CommonHeaderView: UICollectionReusableView {
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemGray, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(title: String?, color: UIColor = .white) {
        if title == "Event" {
            self.titleLabel.textColor = .white
        } else {
            self.titleLabel.textColor = .black
        }
        
        self.titleLabel.text = title
        self.backgroundColor = color
    }
    
    func configureButton(title: String) {
        self.button.isHidden = false
        self.button.setTitle(title, for: .normal)
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            self.button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
