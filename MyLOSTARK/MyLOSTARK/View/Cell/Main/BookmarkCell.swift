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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        addSubview(jobClassImageView)
        addSubview(starButton)
        addSubview(itemLevelLabel)
        addSubview(nameLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.jobClassImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.jobClassImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.jobClassImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.starButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            self.starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
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
