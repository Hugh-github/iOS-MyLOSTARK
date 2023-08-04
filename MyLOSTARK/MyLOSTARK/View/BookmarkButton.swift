//
//  BookmarkButton.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/04.
//

import UIKit

class BookmarkButton: UIButton {
    private let starFillImage = UIImage(systemName: "star.fill")
    private let starImage = UIImage(systemName: "star")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(starFillImage, for: .normal)
        setImage(starImage, for: .highlighted)
        tintColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
