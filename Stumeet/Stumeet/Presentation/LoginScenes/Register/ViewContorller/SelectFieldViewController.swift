//
//  SelectFieldViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

import CombineCocoa

class SelectFieldViewController: BaseViewController {
    
    // MARK: - UIComponents
    private lazy var progressBar: UIView = {
        let view = UIView().makeProgressBar(percent: 0.8)
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "분야를 선택해주세요",
            font: StumeetFont.titleMedium.font,
            color: nil)
        
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = StumeetColor.primary50.color
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let rightImageView = UIImageView(image: UIImage(named: "search"))
        
        textField.rightView = rightImageView
        textField.rightViewMode = .always
        textField.addLeftPadding(24)
        
        return textField
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
    let viewModel: SelecteFieldViewModel
    let coordinator: RegisterCoordinator
    var datasource: UICollectionViewDiffableDataSource<FieldSection, Field>?
    
    // MARK: - Init
    init(viewModel: SelecteFieldViewModel, coordinator: RegisterCoordinator) {
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
            searchTextField,
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
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(searchTextField.snp.bottom).offset(32)
            make.height.equalTo(208)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        
        // Input
        
        let input = SelecteFieldViewModel.Input(
                didSelectField: tagCollectionView.didSelectItemPublisher
            )
        
        let output = viewModel.transform(input: input)
        
        
        // Output
        
        // collectiionview snapshot
        output.fieldItems
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                var snapshot = NSDiffableDataSourceSnapshot<FieldSection, Field>()
                snapshot.appendSections([.main])
                snapshot.appendItems(item)
                
                guard let datasource = self?.datasource else { return }
                datasource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        // nextButton Enable 
        output.isNextButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnable in
                self?.nextButton.isEnabled = isEnable
                self?.nextButton.backgroundColor = isEnable ? StumeetColor.primaryInfo.color : StumeetColor.gray200.color
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

// MARK: - DataSource
extension SelectFieldViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell
            else { return UICollectionViewCell() }
            
            cell.backgroundColor = item.isSelected ? StumeetColor.primaryInfo.color : StumeetColor.primary50.color
            cell.tagLabel.textColor = item.isSelected ? .white : .black
            cell.tagLabel.text = item.field
            return cell
        })
    }
}
