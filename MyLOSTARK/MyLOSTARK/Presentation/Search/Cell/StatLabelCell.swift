//
//  StatLabelCell.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/02.
//

import UIKit

class StatLabelCell: UICollectionViewCell {
    var type: String = "" {
        didSet {
            self.typeLabel.text = type
        }
    }
    
    var value: String? = "" {
        didSet {
            self.valueLabel.text = value
        }
    }
    
    private let statStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
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
        contentView.addSubview(statStackView)
        
        self.statStackView.addArrangedSubview(typeLabel)
        self.statStackView.addArrangedSubview(valueLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.statStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.statStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.statStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.statStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
