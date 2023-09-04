//
//  RecentCharacterCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/28.
//

import UIKit

// TODO: 즐겨 찾기 버튼 추가
class RecentCharacterCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.tintColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bookmarkButton = BookmarkButton()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(deleteButton)
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(levelLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.thumbnailView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 10),
            self.labelStackView.centerYAnchor.constraint(equalTo: thumbnailView.centerYAnchor),
            self.labelStackView.heightAnchor.constraint(equalTo: thumbnailView.heightAnchor, multiplier: 0.9),
            self.labelStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.bookmarkButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5),
            self.bookmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
