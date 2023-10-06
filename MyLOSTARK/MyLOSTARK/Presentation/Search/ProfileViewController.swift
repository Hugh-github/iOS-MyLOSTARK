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
        case equipment
        case accessory
        
        static var selectSectionItem: [String] {
            return ["특성", "장비", "스킬"]
        }
        
        var title: String? {
            switch self {
            case .stat:
                return "전투 특성"
            case .tendency:
                return "성향"
            case .equipment:
                return "장비"
            case .accessory:
                return "악세사리"
            default:
                return nil
            }
        }
    }
    
    var currentIndexPath = IndexPath() {
        didSet {
            if currentIndexPath.item == 0 {
                var snapshot = dataSource.snapshot()
                snapshot.deleteSections([.equipment, .accessory])
                snapshot.appendSections([.stat, .tendency])
                
                self.dataSource.apply(snapshot)
                self.dataSource.apply(statSectionSnapshot, to: .stat)
                self.dataSource.apply(tendencySectionSnapshot, to: .tendency)
            } else if currentIndexPath.item == 1 {
                var snapshot = dataSource.snapshot()
                snapshot.deleteSections([.stat, .tendency])
                snapshot.appendSections([.equipment, .accessory])
                
                self.dataSource.apply(snapshot)
                self.dataSource.apply(equipmentSectionSnapshot, to: .equipment)
                self.dataSource.apply(accessorySectionSnapshot, to: .accessory)
            }
        }
    }
    
    private let bookmarkButton = BookmarkButton()
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    private let director = ProfileCollectionViewLayoutDirector()
    
    var imageProfileSectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
    var statSectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
    var tendencySectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
    var equipmentSectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
    var accessorySectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
    
    private let profileUseCase: CharacterProfileUseCase
    private let interactionUseCase: InterActionCoreDataUseCase
    private let searchUseCase: DefaultSearchUseCase
    private var viewModel: ProfileViewModel! = nil
    
    init(
        profileUseCase: CharacterProfileUseCase,
        interactionUseCase: InterActionCoreDataUseCase,
        searchUseCase: DefaultSearchUseCase
    ) {
        self.profileUseCase = profileUseCase
        self.interactionUseCase = interactionUseCase
        self.searchUseCase = searchUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        navigationItem.backAction = createBackButtonAction()
        
        self.createCollectionView()
        self.configureBookmarkButtonAction()
        self.createViewModel()
        self.configureDataSource()
        self.configureSupplementaryView()
        self.initialSnapshot()
        self.dataBinding()
        
        self.viewModel.execute(.viewDidLoad)
        self.collectionView.selectItem(at: IndexPath(item: 0, section: 1), animated: false, scrollPosition: .init())
        self.currentIndexPath = IndexPath(item: 0, section: 1)
    }
    
    private func createViewModel() {
        self.viewModel = ProfileViewModel(
            profileUseCase: profileUseCase,
            interactionUseCase: interactionUseCase,
            searchUseCase: searchUseCase
        )
    }
    
    private func createBackButtonAction() -> UIAction {
        return UIAction { _ in
            self.viewModel.execute(.didTabBackButton)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 현재 이 방법이 가장 무난하다.
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func configureBookmarkButtonAction() {
        let action = UIAction { action in
            let button = action.sender as? BookmarkButton
            button?.toggle()
            self.viewModel.execute(.didTabBookmarkButton)
        }
        
        self.bookmarkButton.addAction(action, for: .touchUpInside)
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
    }
}

// MARK: Configure CollectionView
extension ProfileViewController {
    private func createCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: setLayout())
        self.collectionView.backgroundColor = .secondarySystemBackground
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.delegate = self
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
            case .equipment:
                return self.director.getArmorySectionLayout()
            case .accessory:
                return self.director.getArmorySectionLayout()
            case .none:
                return nil
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
}


// MARK: Confioure DataSource & SupplementaryView
extension ProfileViewController {
    private func configureDataSource() {
        let imageProfileCellRegistration = createImageProfileCellRegistration()
        let selectContentCellRegistration = createContentSelectCellRegistration()
        let statCellRegistration = createStatCellRegistration()
        let tendencyCellRegistration = createTendencyCellRegistration()
        let equipmentCellRegistration = createEquipmentCellRegistration()
        let accessoryCellRegistration = createAccessoryCellRegistration()
        
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
            case .equipment:
                return collectionView.dequeueConfiguredReusableCell(
                    using: equipmentCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? EquipmentItemViewModel
                )
            case .accessory:
                return collectionView.dequeueConfiguredReusableCell(
                    using: accessoryCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? AccessoryItemViewModel
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
            case .equipment:
                header.setTitle(section?.title)
            case .accessory:
                header.setTitle(section?.title)
            default:
                break
            }
            
            return header
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileViewSection, AnyHashable>()
        snapshot.appendSections([.imageProfile, .select])
        snapshot.appendItems(ProfileViewSection.selectSectionItem, toSection: .select)
        
        self.dataSource.apply(snapshot)
    }
}

// MARK: DataBinding
extension ProfileViewController {
    private func dataBinding() {
        self.viewModel.profile.addObserver(on: self) { [weak self] profile in
            guard let self = self else { return }
            guard let profile = profile else { return }
            
            self.imageProfileSectionSnapshot.append([profile])
            self.dataSource.apply(imageProfileSectionSnapshot, to: .imageProfile)
        }
        
        self.viewModel.isBookmark.addObserver(on: self) { isBookmark in
            self.bookmarkButton.isSelected = isBookmark
        }
        
        self.viewModel.stats.addObserver(on: self) { [weak self] stats in
            guard let self = self else { return }
            
            self.statSectionSnapshot.append(stats)
            self.dataSource.apply(statSectionSnapshot, to: .stat)
        }
        
        self.viewModel.tendencies.addObserver(on: self) { [weak self] tendencies in
            guard let self = self else { return }
            
            self.tendencySectionSnapshot.append(tendencies)
            self.dataSource.apply(tendencySectionSnapshot, to: .tendency)
        }
        
        self.viewModel.equipmentList.addObserver(on: self) { [weak self] equipments in
            guard let self = self else { return }
            
            self.equipmentSectionSnapshot.deleteAll()
            self.equipmentSectionSnapshot.append(equipments)
        }
        
        self.viewModel.accessoryList.addObserver(on: self) { [weak self] accessories in
            guard let self = self else { return }
            
            self.accessorySectionSnapshot.deleteAll()
            self.accessorySectionSnapshot.append(accessories)
        }
    }
}

// MARK: Cell Registration
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
    
    func createEquipmentCellRegistration() -> UICollectionView.CellRegistration<HStackImageLabelCell, EquipmentItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.icon) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                let newImage = image.resize(newHeight: cell.frame.height * 0.7)
                cell.setContent(name: itemIdentifier.name, image: newImage)
            }
        }
    }
    
    func createAccessoryCellRegistration() -> UICollectionView.CellRegistration<HStackImageLabelCell, AccessoryItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.icon) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                let newImage = image.resize(newHeight: cell.iconImageView.frame.height)
                cell.setContent(name: itemIdentifier.name, image: newImage)
            }
        }
    }
}
