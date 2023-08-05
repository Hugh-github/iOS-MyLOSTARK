//
//  BookmarkCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/04.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    private let starButton = BookmarkButton()
    
    private let jobClassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let itemLevelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        setLayout()
        
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(jobClassImageView)
        contentView.addSubview(starButton)
        contentView.addSubview(itemLevelLabel)
        contentView.addSubview(nameLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.jobClassImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.jobClassImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            self.jobClassImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            self.jobClassImageView.widthAnchor.constraint(equalTo: jobClassImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.starButton.topAnchor.constraint(equalTo: topAnchor),
            self.starButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.starButton.widthAnchor.constraint(equalToConstant: 30),
            self.starButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        NSLayoutConstraint.activate([
            self.itemLevelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.itemLevelLabel.topAnchor.constraint(equalTo: jobClassImageView.bottomAnchor, constant: 10)
        ])

        NSLayoutConstraint.activate([
            self.nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.nameLabel.topAnchor.constraint(equalTo: itemLevelLabel.bottomAnchor, constant: 10)
        ])
    }
    
    func setContent(image: UIImage?, level: String?, name: String?) {
        self.jobClassImageView.image = image
        self.itemLevelLabel.text = level
        self.nameLabel.text = name
    }
}
