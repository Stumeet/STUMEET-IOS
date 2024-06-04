//
//  StudyActivityListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

class StudyActivityListViewController: BaseViewController {

    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createAllLayout(type: .all(nil)))
        collectionView.register(StudyActivityAllCell.self, forCellWithReuseIdentifier: StudyActivityAllCell.identifier)
        collectionView.register(
            StudyActivityHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StudyActivityHeaderView.identifier)
        collectionView.backgroundColor = StumeetColor.primary50.color
        
        return collectionView
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addFloatingButton"), for: .normal)
        
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: StudyActivityViewModel
    private let coordinator: StudyListNavigation
    private var datasource: UICollectionViewDiffableDataSource<StudyActivitySection, StudyActivityItem>?
    // TODO: - HeadrView 제거, subject로 연결
    private var headerView: StudyActivityHeaderView?
    
    // MARK: - Init
    init(viewModel: StudyActivityViewModel, coordinator: StudyListNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
        configureXButtonTitleNavigationBarItems(title: "활동")
    }
    
    override func setupAddView() {
        [
            collectionView,
            floatingButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(48)
            make.width.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
        let input = StudyActivityViewModel.Input(
            didTapCreateButton: floatingButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        // TODO: - ViewModel Biniding
        collectionView.didSelectItemPublisher
            .map { _ in }
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.goToDetailStudyActivityVC)
            .store(in: &cancellables)
        
        // collectionview 아이템 바인딩
        output.items
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self = self,
                      let datasource = self.datasource else { return }
                var snapshot = NSDiffableDataSourceSnapshot<StudyActivitySection, StudyActivityItem>()
                snapshot.appendSections([.main])
                
                switch items.first {
                case .all:
                    self.collectionView.setCollectionViewLayout(self.createAllLayout(type: .all(nil)), animated: false)
                    self.collectionView.backgroundColor = StumeetColor.primary50.color
                    
                case .group:
                    self.collectionView.setCollectionViewLayout(self.createAllLayout(type: .group(nil)), animated: false)
                    self.collectionView.backgroundColor = .white
                    
                case .task:
                    self.collectionView.setCollectionViewLayout(self.createAllLayout(type: .task(nil)), animated: false)
                    self.collectionView.backgroundColor = .white
                    
                case .none:
                    break
                }
                self.collectionView.contentOffset = .zero
                snapshot.appendItems(items, toSection: .main)
                datasource.apply(snapshot, animatingDifferences: false)
                
            }
            .store(in: &cancellables)
        
        // 버튼 선택 상태 업데이트
        output.isSelected
            .receive(on: RunLoop.main)
            .sink { [weak self] isSelecteds in
                self?.headerView?.allButton.isSelected = isSelecteds[0]
                self?.headerView?.groupButton.isSelected = isSelecteds[1]
                self?.headerView?.taskButton.isSelected = isSelecteds[2]
            }
            .store(in: &cancellables)
        
        output.presentToCreateActivityVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.startCreateActivityCoordinator)
            .store(in: &cancellables)
    }
}

// MARK: - DataSource

extension StudyActivityListViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyActivityAllCell.identifier,
                for: indexPath) as? StudyActivityAllCell else { return UICollectionViewCell() }
            
            switch item {
            case .all(let item):
                cell.configureAllUI(item: item!)
            case .group(let item):
                cell.configureGroupUI(item: item!)
            case .task(let item):
                cell.configureTaskUI(item: item!)
            }
            
            return cell
        })
        
        datasource?.supplementaryViewProvider = { collectionview, _, indexPath in
            guard let header = collectionview.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: StudyActivityHeaderView.identifier,
                for: indexPath) as? StudyActivityHeaderView else { return UICollectionReusableView() }
            
            header.allButton.tapPublisher
                .sink(receiveValue: { [weak self] _ in self?.viewModel.didTapAllButton.send()})
                .store(in: &header.cancellables)
            
            header.taskButton.tapPublisher
                .sink(receiveValue: { [weak self] _ in self?.viewModel.didTapTaskButton.send()})
                .store(in: &header.cancellables)
            
            header.groupButton.tapPublisher
                .sink(receiveValue: { [weak self] _ in self?.viewModel.didTapGroupButton.send()})
                .store(in: &header.cancellables)
            
            self.headerView = header
            
            return header
        }
    }
}

// MARK: ConfigureLayout

extension StudyActivityListViewController {
    
    private func createAllLayout(type: StudyActivityItem) -> UICollectionViewCompositionalLayout {
        var layout: UICollectionViewCompositionalLayout
        
        switch type {
        case .all:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize
                , elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [sectionHeader]
            section.interGroupSpacing = 24
            layout = UICollectionViewCompositionalLayout(section: section)
            
        case .group, .task:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize
                , elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            
            layout = UICollectionViewCompositionalLayout(section: section)
        }
        return layout
    }
}
