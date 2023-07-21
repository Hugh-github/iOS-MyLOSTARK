//
//  VStackImageLabelCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/21.
//

import UIKit

class VStackImageLabelCell: UICollectionViewCell {
    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        addSubview(vStackView)
        self.vStackView.addArrangedSubview(thumbnailView)
        self.vStackView.addArrangedSubview(textLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.vStackView.topAnchor.constraint(equalTo: topAnchor),
            self.vStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.vStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.vStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.thumbnailView.topAnchor.constraint(equalTo: self.vStackView.topAnchor, constant: 5),
            self.thumbnailView.widthAnchor.constraint(equalTo: self.vStackView.widthAnchor, multiplier: 0.8)
        ])
    }
}
