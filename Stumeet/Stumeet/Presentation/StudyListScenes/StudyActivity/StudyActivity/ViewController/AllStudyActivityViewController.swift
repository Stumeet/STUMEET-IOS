//
//  AllStudyActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import UIKit

final class AllStudyActivityViewController: BaseViewController {
    
    typealias Section = StudyActivitySection
    typealias SectionItem = StudyActivitySectionItem
    
    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(StudyActivityCell.self, forCellWithReuseIdentifier: StudyActivityCell.identifier)
        collectionView.backgroundColor = StumeetColor.primary50.color
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private let viewModel: AllStudyActivityViewModel
    private let coordinator: StudyListNavigation
    
    // MARK: - Init
    
    init(viewModel: AllStudyActivityViewModel, coordinator: StudyListNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatasource()
        view.backgroundColor = .red
    }
    
    override func setupStyles() {
        
    }
    
    override func setupAddView() {
        [
            collectionView
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func bind() {
        let input = AllStudyActivityViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        collectionView.didSelectItemPublisher
            .map { _ in }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.goToDetailStudyActivityVC)
            .store(in: &cancellables)
        
        output.items
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
    }
}

// MARK: - Datasource

extension AllStudyActivityViewController {
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyActivityCell.identifier,
                for: indexPath) as? StudyActivityCell else { return UICollectionViewCell() }
            
            switch item {
            case .all(let item):
                cell.configureAllUI(item: item!)
                
            default: break
            }
            
            return cell
        })
    }
    
    private func updateSnapshot(items: [StudyActivitySectionItem]) {
        guard let datasource = self.datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<StudyActivitySection, StudyActivitySectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Layout

extension AllStudyActivityViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 24
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
