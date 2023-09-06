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
        
        setImage(starImage, for: .normal)
        setImage(starFillImage, for: .selected)
        tintColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggle() {
        isSelected.toggle()
    }
}
