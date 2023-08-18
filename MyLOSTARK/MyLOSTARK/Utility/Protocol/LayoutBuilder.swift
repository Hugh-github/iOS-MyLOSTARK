//
//  LayoutBuilder.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import UIKit

protocol LayoutBuilder {
    func setItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> CollectionViewLayoutBuilder
    
    func setGroup(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, direction: Direction) -> CollectionViewLayoutBuilder
    
    func setGroupInset(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> CollectionViewLayoutBuilder
    
    func getSectionLayout() -> NSCollectionLayoutSection?
}
