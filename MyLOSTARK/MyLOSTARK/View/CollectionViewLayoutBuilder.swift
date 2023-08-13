//
//  CollectionViewLayoutBuilder.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/12.
//

import UIKit

enum Direction {
    case horizontal
    case vertical
}

enum ContentInset {
    case top(CGFloat)
    case bottom(CGFloat)
    case leading(CGFloat)
    case trailing(CGFloat)
    case all(CGFloat)
}

protocol LayoutBuilder {
    func setItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> CollectionViewLayoutBuilder
    
    func setGroup(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, direction: Direction) -> CollectionViewLayoutBuilder
    
    func setGroupInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> CollectionViewLayoutBuilder
    
    func getSectionLayout() -> NSCollectionLayoutSection?
}

class CollectionViewLayoutBuilder: LayoutBuilder {
    private var item: [NSCollectionLayoutItem] = []
    private var group: NSCollectionLayoutGroup?
    private var section: NSCollectionLayoutSection?
    
    func setItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> CollectionViewLayoutBuilder {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        self.item.append(NSCollectionLayoutItem(layoutSize: itemSize))
        
        return self
    }
    
    func setGroup(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, direction: Direction) -> CollectionViewLayoutBuilder {
        
        let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        
        switch direction {
        case .horizontal:
            self.group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: item)
            return self
        case .vertical:
            self.group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: item)
            return self
        }
    }
    
    func setGroupInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> CollectionViewLayoutBuilder {
        self.group?.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)

        return self
    }
    
    func getSectionLayout() -> NSCollectionLayoutSection? {
        guard let group = group else { return nil }
        let section = NSCollectionLayoutSection(group: group)
        self.item.removeAll()
        
        return section
    }
}

extension NSCollectionLayoutSection {
    func setGroupSpacing(_ spacing: CGFloat) {
        interGroupSpacing = spacing
    }
    
    func setScrollingBehavior(_ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) {
        orthogonalScrollingBehavior = behavior
    }
}
