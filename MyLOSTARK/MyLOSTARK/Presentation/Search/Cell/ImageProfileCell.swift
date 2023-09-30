//
//  ImageProfileCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/30.
//

import UIKit

class ImageProfileCell: UICollectionViewCell {
    var image: UIImage! = nil {
        didSet {
            self.imageView.image = image.resize(newWidth: imageView.frame.width)
        }
    }
    
    var name: String = "" {
        didSet {
            self.profileNameLabel.text = name
        }
    }
    
    var server: String = "" {
        didSet {
            self.profileServerLabel.text = server
        }
    }
    
    var jobClass: String = "" {
        didSet {
            self.profileClassLabel.text = jobClass
        }
    }
    
    var level: String = "" {
        didSet {
            self.profileLevelLabel.text = level
        }
    }
    
    var itemLevel: String = "" {
        didSet {
            self.profileItemLevelLabel.text = itemLevel
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let profileServerLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let profileClassLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let profileLevelLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let profileItemLevelLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(red: 21/255, green: 24/255, blue: 28/255, alpha: 1.0)
        self.addSubView()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        contentView.addSubview(profileStackView)
        contentView.addSubview(imageView)
        
        self.profileStackView.addArrangedSubview(profileNameLabel)
        self.profileStackView.addArrangedSubview(profileServerLabel)
        self.profileStackView.addArrangedSubview(profileClassLabel)
        self.profileStackView.addArrangedSubview(profileLevelLabel)
        self.profileStackView.addArrangedSubview(profileItemLevelLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.profileStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            self.profileStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            self.profileStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            self.profileStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            self.imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            self.imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            self.imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            self.imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)
        ])
    }
}
