//
//  ProfileViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/27.
//

import UIKit

class ProfileViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<ProfileViewSection, AnyHashable>
    
    enum ProfileViewSection {
        case imageProfile
        case select
        case stat
        case tendency
        
        static var selectSectionItem: [String] {
            return ["스탯", "장비", "스킬"]
        }
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    private let director = ProfileCollectionViewLayoutDirector()
    
    private let profileUseCase: CharacterProfileUseCase
    private var viewModel: ProfileViewModel! = nil
    
    init(profileUseCase: CharacterProfileUseCase) {
        self.profileUseCase = profileUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.createCollectionView()
        self.createViewModel()
        self.configureDataSource()
        self.initialSnapshot()
        self.dataBinding()
        
        self.viewModel.execute(.viewDidLoad)
    }
    
    private func createViewModel() {
        self.viewModel = ProfileViewModel(profileUseCase: profileUseCase)
    }
    
    private func createCollectionView() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setLayout())
        self.collectionView.backgroundColor = .secondarySystemBackground
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(collectionView)
    }
    
    private func setLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.dataSource.sectionIdentifier(for: sectionIndex)
            
            switch section {
            case .imageProfile:
                return self.director.getImageProfileSection()
            case .select:
                return self.director.getSelectSectionLayout()
            case .stat:
                return self.director.getStatSectionLayout()
            case .tendency:
                return self.director.getTendencySectionLayout()
            case .none:
                return nil
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    private func configureDataSource() {
        let imageProfileCellRegistration = createImageProfileCellRegistration()
        let selectContentCellRegistration = createContentSelectCell()
        
        self.dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section)
            
            switch sectionIdentifier {
            case .imageProfile:
                return collectionView.dequeueConfiguredReusableCell(
                    using: imageProfileCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? CharacterProfileViewModel
                )
            case .select:
                return collectionView.dequeueConfiguredReusableCell(
                    using: selectContentCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? String
                )
            default:
                return nil
            }
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileViewSection, AnyHashable>()
        snapshot.appendSections([.imageProfile, .select])
        snapshot.appendItems(ProfileViewSection.selectSectionItem, toSection: .select)
        
        self.dataSource.apply(snapshot)
    }
    
    private func dataBinding() {
        self.viewModel.profile.addObserver(on: self) { profile in
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems([profile], toSection: .imageProfile)
            self.dataSource.apply(snapshot)
        }
    }
}

extension ProfileViewController {
    func createImageProfileCellRegistration() -> UICollectionView.CellRegistration<ImageProfileCell, CharacterProfileViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let imageURL = itemIdentifier.characterImage,
                  let url = URL(string: imageURL) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.name = itemIdentifier.characterName
                cell.server = itemIdentifier.serverName
                cell.jobClass = itemIdentifier.characterClassName
                cell.level = itemIdentifier.characterLevel
                cell.itemLevel = itemIdentifier.itemAvgLevel
                cell.image = image
            }
        }
    }
    
    func createContentSelectCell() -> UICollectionView.CellRegistration<ContentSelectCell, String> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.content = itemIdentifier
        }
    }
}
