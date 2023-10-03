//
//  ProfileHeaderView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/03.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .cyan
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubview(titleLabel)
        addSubview(lineView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            self.titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            self.lineView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            self.lineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.lineView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.lineView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, multiplier: 0.1)
        ])
    }
    
    func setTitle(_ title: String?) {
        self.titleLabel.text = title
    }
}
