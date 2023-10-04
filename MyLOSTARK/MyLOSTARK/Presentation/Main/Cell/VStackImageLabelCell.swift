//
//  VStackImageLabelCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/21.
//

import UIKit

class VStackImageLabelCell: UICollectionViewCell {
    private(set) var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
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
        contentView.addSubview(thumbnailView)
        contentView.addSubview(textLabel)
    }
    
    override func prepareForReuse() {
        self.thumbnailView.image = nil
        self.textLabel.text = nil
    }

    private func setLayout() {
        NSLayoutConstraint.activate([
            self.thumbnailView.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.thumbnailView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.thumbnailView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
        
        NSLayoutConstraint.activate([
            self.textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.textLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setContent(title: String, image: UIImage?) {
        self.textLabel.text = title
        
        let newImage = image?.resize(newWidth: thumbnailView.frame.width)
        self.thumbnailView.image = newImage
        self.thumbnailView.layoutIfNeeded()
    }
    
    func setTextColor(_ color: UIColor) {
        self.textLabel.textColor = color
    }
}
