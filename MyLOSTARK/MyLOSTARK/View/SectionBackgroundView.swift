//
//  SectionBackgroundView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/05.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class SectionBackgroundView: UICollectionReusableView {
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            self.backgroundView.topAnchor.constraint(equalTo: topAnchor),
            self.backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
