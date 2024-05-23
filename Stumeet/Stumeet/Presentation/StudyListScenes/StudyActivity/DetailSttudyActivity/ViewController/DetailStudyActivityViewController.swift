//
//  DetailStudyActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/23/24.
//

import UIKit

final class DetailStudyActivityViewController: BaseViewController {

    typealias Section = DetailStudyActivitySection
    typealias SectionItem = DetailStudyActivitySectionItem
    
    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(DetailStudyActivityTopCell.self, forCellWithReuseIdentifier: DetailStudyActivityTopCell.identifier)
        collectionView.register(DetailStudyActivityPhotoCell.self, forCellWithReuseIdentifier: DetailStudyActivityPhotoCell.identifer)
        collectionView.register(DetailStudyActivityBottomCell.self, forCellWithReuseIdentifier: DetailStudyActivityBottomCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private let coordinator: StudyListNavigation
    
    // MARK: - Init
    
    init(coordinator: StudyListNavigation) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - SetUp
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            collectionView
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK: - Bind
    
    override func bind() {
        configureDatasource()
        let top = DetailStudyActivityTop(dayLeft: "", status: "", profileImageURL: "", name: "", date: "", title: "", content: "")
        let photo = DetailStudyActivityPhoto(imageURL: "")
        let bottom = DetailStudyActivityBottom(memberImageURL: [""], startDate: "", endDate: "", place: "")
        let items: [SectionItem] = [
            .topCell(top),
            .photoCell(photo),
            .bottomCell(bottom)
        ]
        updateSnapshot(items: items)
    }
}

// MARK: - CompositionalLayout

extension DetailStudyActivityViewController {
    
    private func detailStudyActivityTopCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(195))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(195))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
    
    private func detailStudyActivityPhotoCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.44), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
    
    private func detailStudyActivityBottomCellCompositionalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(172))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(172))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                return self?.detailStudyActivityTopCellCompositionalLayout()
            case 1:
                return self?.detailStudyActivityPhotoCellCompositionalLayout()
            case 2:
                return self?.detailStudyActivityBottomCellCompositionalLayout()
            default: return nil
            }
        }
    }
}

extension DetailStudyActivityViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .topCell(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetailStudyActivityTopCell.identifier,
                    for: indexPath) as? DetailStudyActivityTopCell
                else { return UICollectionViewCell() }
                
                return cell
                
            case .photoCell(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetailStudyActivityPhotoCell.identifer,
                    for: indexPath) as? DetailStudyActivityPhotoCell
                else { return UICollectionViewCell() }
                
                return cell
                
            case .bottomCell(let item):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetailStudyActivityBottomCell.identifier,
                    for: indexPath) as? DetailStudyActivityBottomCell
                else { return UICollectionViewCell() }
                
                return cell
            }
        })
    }
    private func updateSnapshot(items: [SectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.top, .photo, .bottom])
        items.forEach { snapshot.appendItems([$0]) }
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
