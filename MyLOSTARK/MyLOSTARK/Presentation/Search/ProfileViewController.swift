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
            return ["특성", "장비", "스킬"]
        }
        
        var title: String? {
            switch self {
            case .stat:
                return "전투 특성"
            case .tendency:
                return "성향"
            default:
                return nil
            }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: BookmarkButton())
        
        self.createCollectionView()
        self.createViewModel()
        self.configureDataSource()
        self.configureSupplementaryView()
        self.initialSnapshot()
        self.dataBinding()
        
        self.viewModel.execute(.viewDidLoad)
    }
    
    private func createViewModel() {
        self.viewModel = ProfileViewModel(profileUseCase: profileUseCase)
    }
    
    private func createCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        self.collectionView.backgroundColor = .secondarySystemBackground
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.register(
            ProfileHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        let selectContentCellRegistration = createContentSelectCellRegistration()
        let statCellRegistration = createStatCellRegistration()
        let tendencyCellRegistration = createTendencyCellRegistration()
        
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
            case .stat:
                return collectionView.dequeueConfiguredReusableCell(
                    using: statCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? CharacterStatsViewModel
                )
            case .tendency:
                return collectionView.dequeueConfiguredReusableCell(
                    using: tendencyCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? CharacterTendencyViewModel
                )
            default:
                return nil
            }
        }
    }
    
    private func configureSupplementaryView() {
        self.dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath -> UICollectionReusableView? in
            let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: ProfileHeaderView.reuseIdentifier,
                for: indexPath
            ) as? ProfileHeaderView else {
                return nil
            }
            
            switch section {
            case .stat:
                header.setTitle(section?.title)
            case .tendency:
                header.setTitle(section?.title)
            default:
                break
            }
            
            return header
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileViewSection, AnyHashable>()
        snapshot.appendSections([.imageProfile, .select, .stat, .tendency])
        snapshot.appendItems(ProfileViewSection.selectSectionItem, toSection: .select)
        
        self.dataSource.apply(snapshot)
    }
    
    private func dataBinding() {
        self.viewModel.profile.addObserver(on: self) { profile in
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems([profile], toSection: .imageProfile)
            self.dataSource.apply(snapshot)
        }
        
        self.viewModel.stats.addObserver(on: self) { stats in
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(stats, toSection: .stat)
            self.dataSource.apply(snapshot)
        }
        self.viewModel.tendencies.addObserver(on: self) { tendencies in
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(tendencies, toSection: .tendency)
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
    
    func createContentSelectCellRegistration() -> UICollectionView.CellRegistration<ContentSelectCell, String> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.content = itemIdentifier
        }
    }
    
    func createStatCellRegistration() -> UICollectionView.CellRegistration<StatLabelCell, CharacterStatsViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.type = itemIdentifier.type
            cell.value = itemIdentifier.value
        }
    }
    
    func createTendencyCellRegistration() -> UICollectionView.CellRegistration<StatLabelCell, CharacterTendencyViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.type = itemIdentifier.type
            cell.value = String(itemIdentifier.point)
        }
    }
}
