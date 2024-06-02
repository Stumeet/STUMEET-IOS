//
//  StudyActivityListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

class StudyActivityListViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.isSelected = true
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        
        return button
    }()
    
    private let groupButton: UIButton = {
        let button = UIButton()
        button.setTitle("모임", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.titleLabel?.font = StumeetFont.titleMedium.font
        button.sizeToFit()
        return button
    }()
    
    private let taskButton: UIButton = {
        let button = UIButton()
        button.setTitle("과제", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.titleLabel?.font = StumeetFont.titleMedium.font
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createAllLayout(type: .all(nil)))
        collectionView.register(StudyActivityAllCell.self, forCellWithReuseIdentifier: StudyActivityAllCell.identifier)
        collectionView.backgroundColor = StumeetColor.primary50.color
        
        return collectionView
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addFloatingButton"), for: .normal)
        
        return button
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(StumeetColor.gray800.color), for: .normal)
        return button
    }()
    
    private lazy var xBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: xButton)
    }()
    
    // MARK: - Properties
    
    private let viewModel: StudyActivityViewModel
    private let coordinator: StudyListNavigation
    private var datasource: UICollectionViewDiffableDataSource<StudyActivitySection, StudyActivityItem>?
    
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
        configureXButtonTitleNavigationBarItems(button: xBarButton, title: "활동")
    }
    
    override func setupAddView() {
        [
            allButton,
            groupButton,
            taskButton
        ]   .forEach(buttonStackView.addArrangedSubview)
        
        [
            buttonStackView,
            collectionView,
            floatingButton
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.width.equalTo(137)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
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
        
        // TODO: - xButton 이벤트 처리
        
        let input = StudyActivityViewModel.Input(
            didTapCreateButton: floatingButton.tapPublisher,
            didTapAllButton: allButton.tapPublisher,
            didTapGroupButton: groupButton.tapPublisher,
            didTapTaskButton: taskButton.tapPublisher,
            didTapXButton: xButton.tapPublisher
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
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        // 버튼 선택 상태 업데이트
        output.isSelected
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSelectedButton)
            .store(in: &cancellables)
        
        // 활동 생성VC로 present
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
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 24
            layout = UICollectionViewCompositionalLayout(section: section)
            
        case .group, .task:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            
            let section = NSCollectionLayoutSection(group: group)
            
            layout = UICollectionViewCompositionalLayout(section: section)
        }
        return layout
    }
}

// MARK: - UIUpdate

extension StudyActivityListViewController {
    private func updateSnapshot(items: [StudyActivityItem]) {
        guard let datasource = self.datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<StudyActivitySection, StudyActivityItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        
        setCollectionvViewLayout(items: items)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func setCollectionvViewLayout(items: [StudyActivityItem]) {
        switch items.first {
        case .all:
            collectionView.setCollectionViewLayout(createAllLayout(type: .all(nil)), animated: false)
            collectionView.backgroundColor = StumeetColor.primary50.color
            
        case .group:
            collectionView.setCollectionViewLayout(createAllLayout(type: .group(nil)), animated: false)
            collectionView.backgroundColor = .white
            
        case .task:
            collectionView.setCollectionViewLayout(createAllLayout(type: .task(nil)), animated: false)
            collectionView.backgroundColor = .white
            
        case .none:
            break
        }
        
        collectionView.contentOffset = .zero
    }
    
    private func updateSelectedButton(isSelecteds: [Bool]) {
        allButton.isSelected = isSelecteds[0]
        groupButton.isSelected = isSelecteds[1]
        taskButton.isSelected = isSelecteds[2]
    }
}
