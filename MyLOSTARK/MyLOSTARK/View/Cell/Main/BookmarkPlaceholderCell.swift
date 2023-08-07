//
//  BookmarkPlaceholderCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/05.
//

import UIKit

class BookmarkPlaceholderCell: UICollectionViewCell {
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
//    private let actionButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("캐릭터 등록하기", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
//        button.backgroundColor = .cyan
//        button.layer.cornerRadius = 5
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(placeholderImageView)
        contentView.addSubview(descriptionLabel)
//        contentView.addSubview(actionButton)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.placeholderImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            self.placeholderImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
        ])
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.descriptionLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10)
        ])
        
//        NSLayoutConstraint.activate([
//            self.actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            self.actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
//            self.actionButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
//        ])
    }
    
    func setContent(image: UIImage?, text: String?) {
        self.placeholderImageView.image = image
        self.descriptionLabel.text = text
    }
}
