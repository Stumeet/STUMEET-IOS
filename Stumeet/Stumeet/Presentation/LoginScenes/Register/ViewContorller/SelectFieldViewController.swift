//
//  SelectFieldViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

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
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = StumeetColor.primary50.color
        textField.layer.cornerRadius = 10
        
        let rightImageView = UIImageView(image: UIImage(named: "search"))
        
        let rightViewContainer = UIView()
        rightViewContainer.frame = CGRect(x: 0, y: 0, width: rightImageView.frame.width, height: rightImageView.frame.height)
        rightImageView.frame = CGRect(x: -24, y: 0, width: rightImageView.frame.width, height: rightImageView.frame.height)
        rightViewContainer.addSubview(rightImageView)
        
        textField.rightView = rightViewContainer
        textField.rightViewMode = .always
        textField.addLeftPadding(24)
        
        return textField
    }()
    
    private lazy var fieldTableView: UITableView = {
        let tableView = UITableView(frame: .init())
        
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.layer.cornerRadius = 10
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.rowHeight = 56
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }()
    

    private lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        
        return collectionView
    }()
    
    
    private lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음", color: StumeetColor.gray200.color)
        
        return button
    }()
    
    // MARK: - Properties
    private let viewModel: SelecteFieldViewModel
    private let coordinator: RegisterCoordinator
    private var tagDatasource: UICollectionViewDiffableDataSource<FieldSection, Field>?
    private var fieldDataSource: UITableViewDiffableDataSource<FieldSection, Field>?
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fieldTableView.layer.addBorder([.left, .right, .bottom], color: StumeetColor.gray100.color, width: 1)
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
            fieldTableView,
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
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        fieldTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(searchTextField.snp.bottom).offset(-10)
            make.height.equalTo(280)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
    
    override func bind() {
        
        // MARK: - Input
        
        let input = SelecteFieldViewModel.Input(
                didSelectField: tagCollectionView.didSelectItemPublisher,
                didSearchField: searchTextField.textPublisher,
                didSelectSearchedField: fieldTableView.didSelectRowPublisher,
                didTapNextButton: nextButton.tapPublisher
            )
        
        let output = viewModel.transform(input: input)
        
        
        // MARK: - Output
        
        // 태그 리스트 snapshot
        output.fieldItems
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                if !(self?.fieldTableView.isHidden)! {
                    self?.fieldTableView.isHidden = true
                }
                var snapshot = NSDiffableDataSourceSnapshot<FieldSection, Field>()
                snapshot.appendSections([.main])
                snapshot.appendItems(item)
                
                guard let datasource = self?.tagDatasource else { return }
                datasource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        // 다음 버튼 Enable
        output.isNextButtonEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnable in
                self?.nextButton.isEnabled = isEnable
                self?.nextButton.backgroundColor = isEnable ? StumeetColor.primaryInfo.color : StumeetColor.gray200.color
            }
            .store(in: &cancellables)
        
        // 검색 리스트 snapshot
        output.searchedItems
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                
                self?.fieldTableView.isHidden = item.isEmpty
                var snapshot = NSDiffableDataSourceSnapshot<FieldSection, Field>()
                snapshot.appendSections([.main])
                snapshot.appendItems(item)
                
                guard let datasource = self?.fieldDataSource else { return }
                datasource.apply(snapshot, animatingDifferences: false)
            }
            .store(in: &cancellables)
        
        output.presentToTabBar
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.coordinator.presentToTabBar()
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
    private func configureDatasource() {
        tagDatasource = UICollectionViewDiffableDataSource(collectionView: tagCollectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell
            else { return UICollectionViewCell() }
            
            cell.backgroundColor = item.isSelected ? StumeetColor.primaryInfo.color : StumeetColor.primary50.color
            cell.tagLabel.textColor = item.isSelected ? .white : .black
            cell.tagLabel.text = item.name
            return cell
        })
        
        fieldDataSource = UITableViewDiffableDataSource(tableView: fieldTableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = item.name
            cell.textLabel?.font = StumeetFont.bodyMedium16.font
            cell.textLabel?.textColor = StumeetColor.gray400.color
            cell.selectionStyle = .none
            
            return cell
        })
    }
}
