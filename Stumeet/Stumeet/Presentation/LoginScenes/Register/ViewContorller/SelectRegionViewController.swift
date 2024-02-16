//
//  SelectRegionViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import Combine
import UIKit

import CombineCocoa

class SelectRegionViewController: BaseViewController {

    // MARK: - UIComponents
    private lazy var progressBar: UIView = {
        let view = UIView().makeProgressBar(percent: 0.6)
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "지역을 선택해주세요",
            font: .boldSystemFont(ofSize: 20),
            color: nil)
        
        return label
    }()
    
    
    lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isScrollEnabled = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        
        return collectionView
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음", color: StumeetColor.gray200.color)
        
        return button
    }()
    
    // MARK: - Properties
    let coordinator: RegisterCoordinator
    let viewModel: SelectRegionViewModel
    var datasource: UICollectionViewDiffableDataSource<RegionSection, Region>?
    
    // MARK: - Init
    init(viewModel: SelectRegionViewModel, coordinator: RegisterCoordinator) {
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
        
        configureRegisterNavigationBarItems()
        configureDatasource()
    }
    
    // MARK: - Setup
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            progressBar,
            titleLabel,
            tagCollectionView,
            nextButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(96)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        
        // Input
        
        let input = SelectRegionViewModel.Input(
            didSelectItem: tagCollectionView.didSelectItemPublisher,
            didTapNextButton: nextButton.tapPublisher
        )
        
        // Output
        
        let output = viewModel.transform(input: input)
        
        // collectiionview snapshot
        output.regionItems
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                var snapshot = NSDiffableDataSourceSnapshot<RegionSection, Region>()
                snapshot.appendSections([.main])
                snapshot.appendItems(item)
                
                guard let datasource = self?.datasource else { return }
                datasource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        // nextButton Enalbe
        output.isNextButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnable in
                self?.nextButton.isEnabled = isEnable
                self?.nextButton.backgroundColor = isEnable ? StumeetColor.primaryInfo.color : StumeetColor.gray200.color
            }
            .store(in: &cancellables)
        
        // navigateToSelectFieldVC
        output.navigateToSelectFieldVC
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator.navigateToSelectFieldVC()
            }
            .store(in: &cancellables)

    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Datasource
extension SelectRegionViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell
            else { return UICollectionViewCell() }
            
            cell.backgroundColor = item.isSelected ? StumeetColor.primaryInfo.color : StumeetColor.primary50.color
            cell.tagLabel.textColor = item.isSelected ? .white : .black
            cell.tagLabel.text = item.region
            return cell
        })
    }
}
