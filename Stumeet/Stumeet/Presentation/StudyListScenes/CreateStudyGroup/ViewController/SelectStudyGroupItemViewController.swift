//
//  SelectStudyGroupFieldViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import UIKit

protocol SelectStudyGroupItemDelegate: AnyObject {
    func didTapFileldCompleteButton(field: SelectStudyItem)
    func didTapRegionCompleteButton(region: SelectStudyItem)
}

final class SelectStudyGroupItemViewController: BaseViewController {
    
    typealias Section = SelectStudySection
    typealias SectionItem = SelectStudySectionItem
    
    // MARK: - UIComponents
    
    private let titleLabel = UILabel().setLabelProperty(text: nil, font: StumeetFont.titleMedium.font, color: .gray800)
    
    private lazy var fieldCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(TagCell.self)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: SelectStudyItemViewModel
    weak var delegate: SelectStudyGroupItemDelegate?
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: SelectStudyItemViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
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
        configureDatasource()
        configureBackButtonTitleNavigationBarItems(title: viewModel.itemType.naviTitle)
        titleLabel.text = viewModel.itemType.explain
    }
    
    override func setupAddView() {
        [
            titleLabel,
            fieldCollectionView,
            completeButton
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().inset(24)
        }
        
        fieldCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
        let input = SelectStudyItemViewModel.Input(
            didSelectedItem: fieldCollectionView.didSelectItemPublisher,
            didTapCompleteButton: completeButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteButton)
            .store(in: &cancellables)
        
        output.completeItem
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] item, type in
                switch type {
                case .field:
                    self?.delegate?.didTapFileldCompleteButton(field: item)
                case .region:
                    self?.delegate?.didTapRegionCompleteButton(region: item)
                }
                self?.coordinator.popToCreateStudyGroupVC()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Datasource

extension SelectStudyGroupItemViewController {
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: fieldCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .itemCell(let item):
                guard let cell = collectionView.dequeue(TagCell.self, for: indexPath) else { return UICollectionViewCell() }
                cell.configureTagCell(item: item)
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(items: [SectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(35))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - UIUpdate

extension SelectStudyGroupItemViewController {
    func updateCompleteButton(isEnable: Bool) {
        completeButton.isEnabled = isEnable
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
}
