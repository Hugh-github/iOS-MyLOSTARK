//
//  ProfileCollectionViewLayoutDirector.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/02.
//

import UIKit

class ProfileCollectionViewLayoutDirector {
    private let builder = CollectionViewLayoutBuilder() // singleton 고려해보자
    
    func getImageProfileSection() -> NSCollectionLayoutSection? {
        let section = self.builder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.35), direction: .vertical)
            .getSectionLayout()
        
        return section
    }
    
    func getSelectSectionLayout() -> NSCollectionLayoutSection? {
        let section = self.builder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(0.33), height: .fractionalHeight(0.05), direction: .horizontal)
            .getSectionLayout()
        
        section?.setScrollingBehavior(.continuous)
        
        return section
    }
    
    func getStatSectionLayout() -> NSCollectionLayoutSection? {
        let section = self.builder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.1), direction: .vertical)
            .getSectionLayout()
        
        return section
    }
    
    func getTendencySectionLayout() -> NSCollectionLayoutSection? {
        let section = self.builder
            .setItem(width: .fractionalWidth(0.5), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.1), direction: .vertical)
            .getSectionLayout()
        
        return section
    }
}
