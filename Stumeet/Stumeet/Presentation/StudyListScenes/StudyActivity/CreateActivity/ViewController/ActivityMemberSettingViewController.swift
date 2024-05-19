//
//  ActivityMemberSettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/13/24.
//

import UIKit

final class ActivityMemberSettingViewController: BaseViewController {
    
    // MARK: - Typealias
    
    typealias Section = ActivityMemberSection
    typealias SectionItem = ActivityMemberSectionItem
    
    // MARK: - UIComponents
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: "참여 멤버", font: StumeetFont.titleMedium.font, color: .gray800)
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "멤버 이름 검색",
            attributes: [NSAttributedString.Key.foregroundColor: StumeetColor.gray400.color])

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
    
    private let allSelectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "allUnSelectedButton"), for: .normal)
        button.setImage(UIImage(named: "allSelectedButton"), for: .selected)
        
        return button
    }()
    
    private let memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ActivityMemberCell.self, forCellReuseIdentifier: ActivityMemberCell.identifier)
        tableView.rowHeight = 72
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let completeButton: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    }()
    
    // MARK: - Properties
    
    private let coordinator: CreateActivityNavigation
    private let viewModel: ActivityMemberSettingViewModel
    private var datasource: UITableViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Init
    
    init(coordinator: CreateActivityNavigation, viewModel: ActivityMemberSettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
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
    }
    
    override func setupAddView() {
        [
            xButton,
            titleLabel,
            searchTextField,
            allSelectButton,
            memberTableView,
            completeButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.centerY.equalTo(xButton)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.height.equalTo(56)
        }
        
        allSelectButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(searchTextField.snp.bottom).offset(24)
            make.height.equalTo(84)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(allSelectButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(432)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = ActivityMemberSettingViewModel.Input(
            didSelectIndexPathPublisher: memberTableView.didSelectRowPublisher.eraseToAnyPublisher(),
            didTapAllSelectButton: allSelectButton.tapPublisher.map {self.allSelectButton.isSelected}.eraseToAnyPublisher(),
            searchTextPublisher: searchTextField.textPublisher.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        // member binding
        output.members
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        // 전체 선택
        output.isSelectedAll
            .receive(on: RunLoop.main)
            .assign(to: \.isSelected, on: allSelectButton)
            .store(in: &cancellables)
        
    }
}

// MARK: - Datasource

extension ActivityMemberSettingViewController {
    private func configureDatasource() {
        datasource = UITableViewDiffableDataSource(tableView: memberTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .memberCell(let name, let isSelected):
                guard let cell =
                        tableView.dequeueReusableCell(
                            withIdentifier: ActivityMemberCell.identifier,
                            for: indexPath
                        ) as? ActivityMemberCell
                else { return UITableViewCell() }
                cell.configureCell(name, isSelected)
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(items: [SectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        items.forEach { snapshot.appendItems([$0], toSection: .main) }
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
