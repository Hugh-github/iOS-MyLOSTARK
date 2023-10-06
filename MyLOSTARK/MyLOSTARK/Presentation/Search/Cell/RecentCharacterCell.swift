//
//  RecentCharacterCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/28.
//

import UIKit

class RecentCharacterCell: UICollectionViewCell {
    weak var delegate: RecentCharacterCellDelegate?
    
    private(set) var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private(set) var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) var levelLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.tintColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) var bookmarkButton = BookmarkButton()
    
    private(set) var deleteButton: UIButton = {
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
        self.bookmarkButton.addAction(didTabBookmarkButton(), for: .touchUpInside)
        self.deleteButton.addAction(didTabDeleteButton(), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didTabBookmarkButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }
            delegate?.didTabBookmarkButton(cell: self)
        }
    }
    
    private func didTabDeleteButton() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }
            delegate?.didTabDeleteButton(cell: self)
        }
    }
    
    private func addSubview() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(deleteButton)
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(levelLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.thumbnailView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            self.thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            self.labelStackView.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 20),
            self.labelStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            self.labelStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
        
        NSLayoutConstraint.activate([
            self.deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.bookmarkButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -10),
            self.bookmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

protocol RecentCharacterCellDelegate: AnyObject {
    func didTabDeleteButton(cell: RecentCharacterCell)
    func didTabBookmarkButton(cell: RecentCharacterCell)
}
