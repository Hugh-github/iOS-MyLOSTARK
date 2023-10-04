//
//  HStackImageLabelCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/28.
//

import UIKit

class HStackImageLabelCell: UICollectionViewCell {
    private(set) var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(name: String, image: UIImage) {
        let newImage = image.resize(newWidth: self.iconImageView.frame.width)
        
        self.nameLabel.text = name
        self.iconImageView.image = newImage
    }
    
    private func addSubView() {
        contentView.addSubview(self.iconImageView)
        contentView.addSubview(self.nameLabel)
    }
    
    private func setLayout() {
        let spacing = contentView.frame.width * 0.05
        
        NSLayoutConstraint.activate([
            self.iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            self.iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            self.iconImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            self.iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: spacing),
            self.nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
