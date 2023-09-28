//
//  CollectionLayoutDirector.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/17.
//

import UIKit

class MainCollectionViewLayoutDirector {
    private let builder = CollectionViewLayoutBuilder()
    
    func getCalendarLayout() -> NSCollectionLayoutSection? {
        let section = builder
            .setItem(width: .fractionalWidth(0.33), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.26), direction: .horizontal)
            .getSectionLayout()
        section?.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    func getBookmarkLayout() -> NSCollectionLayoutSection? {
        let section = builder
            .setItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.26), direction: .horizontal)
            .setItemSpacing(10)
            .setGroupInset(top: 10, leading: 10, bottom: 10, trailing: 10)
            .getSectionLayout()
        
        section?.setScrollingBehavior(.continuous)
        section?.boundarySupplementaryItems = [self.getHeader()]
        section?.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
        ]
        
        return section
    }
    
    func getPlaceHolderLayout() -> NSCollectionLayoutSection? {
        let section = builder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.19), direction: .horizontal)
            .getSectionLayout()
        
        section?.boundarySupplementaryItems = [self.getHeader(), self.getFooter()]
        section?.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
        ]
        
        return section
    }
    
    func getNoticeLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
        section.boundarySupplementaryItems = [self.getHeader(), self.getFooter()]
        
        return section
    }
    
    func getEventLayout() -> NSCollectionLayoutSection? {
        let section = builder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(0.8), height: .fractionalHeight(0.28), direction: .horizontal)
            .getSectionLayout()
        
        section?.setScrollingBehavior(.groupPaging)
        section?.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
}

extension MainCollectionViewLayoutDirector {
    private func getHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
    
    private func getFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        return footer
    }
}
