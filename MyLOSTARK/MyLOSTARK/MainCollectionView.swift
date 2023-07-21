//
//  MainView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/20.
//

import UIKit

class MainCollectionView: UIView {
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = setSectionLayout()
        
        // Cell 등록하는 로직 추가
        self.collectionView.register(VStackImageLabelCell.self, forCellWithReuseIdentifier: "CalendarAndEventCell")
        self.collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header"
        )
    }
    
    private func setSectionLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionKind = MainViewSection(rawValue: sectionIndex)
            
            switch sectionKind {
            case .calendar:
                return setCalendarLayout()
            case .characterBookmark:
                return setBookmarkLayout()
            case .shopNotice:
                return setShopNoticeLayout(environment: layoutEnvironment)
            case .event:
                return setEventLayout()
            case .none:
                return nil
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    private func setCalendarLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setBookmarkLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setShopNoticeLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setEventLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func getHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.05))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
}
