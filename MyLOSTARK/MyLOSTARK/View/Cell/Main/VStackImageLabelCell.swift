//
//  VStackImageLabelCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/21.
//

import UIKit

class VStackImageLabelCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let textLabel: UILabel = {
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
        addSubview(thumbnailView)
        addSubview(textLabel)
    }

    private func setLayout() {
        NSLayoutConstraint.activate([
            self.thumbnailView.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.thumbnailView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            self.thumbnailView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85)
        ])
        
        NSLayoutConstraint.activate([
            self.textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.textLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    func setContent(title: String, image: UIImage) {
        self.textLabel.text = title
        
        let newImage = image.resize(newWidth: thumbnailView.frame.width)
        self.thumbnailView.image = newImage
    }
    
    func setTextColor(_ color: UIColor) {
        self.textLabel.textColor = color
    }
}

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let newImage = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return newImage
    }
}
