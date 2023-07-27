//
//  CommonHeaderView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/20.
//

import UIKit

class CommonHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(title: String, color: UIColor) {
        if title == "Event" {
            self.titleLabel.textColor = .white
        } else {
            self.titleLabel.textColor = .black
        }
        
        self.titleLabel.text = title
        self.backgroundColor = color
    }
    
    private func setLayout() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
}
