//
//  ContentSelectCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/02.
//

import UIKit

class ContentSelectCell: UICollectionViewCell {
    var content: String = "" {
        didSet {
            self.label.text = content
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                indicatorView.backgroundColor = .gray
            } else {
                indicatorView.backgroundColor = .secondarySystemBackground
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        contentView.addSubview(label)
        contentView.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            self.label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.55)
        ])
        
        NSLayoutConstraint.activate([
            self.indicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.indicatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            self.indicatorView.heightAnchor.constraint(equalToConstant: 3),
            self.indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
