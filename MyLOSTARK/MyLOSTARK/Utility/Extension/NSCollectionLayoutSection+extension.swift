//
//  NSCollectionLayoutSection+extension.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import UIKit

extension NSCollectionLayoutSection {
    func setGroupSpacing(_ spacing: CGFloat) {
        interGroupSpacing = spacing
    }
    
    func setScrollingBehavior(_ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) {
        orthogonalScrollingBehavior = behavior
    }
}
