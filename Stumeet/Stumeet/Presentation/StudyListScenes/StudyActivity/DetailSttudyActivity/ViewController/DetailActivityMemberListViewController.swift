//
//  DetailActivityMemberListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/27/24.
//

import UIKit

class DetailActivityMemberListViewController: BaseViewController {

    typealias Section = ActivityMemberSection
    typealias SectionItem = DetailActivityMemberSectionItem
    
    // MARK: - UIComponents
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(StumeetColor.gray800.color), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: "참여 멤버", font: StumeetFont.titleMedium.font, color: .gray800)
    }()
    
    private let memberCountLabel: UILabel = {
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.titleMedium.font, color: .primary700)
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 72
        tableView.separatorStyle = .none
        tableView.register(ActivityMemberCell.self, forCellReuseIdentifier: ActivityMemberCell.identifier)
        
        return tableView
    }()
    
    // MARK: - Properties
    
    private let coordinator: StudyListNavigation
    private let viewModel: DetailActivityMemberListViewModel
    private var datasource: UITableViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Init
    
    init(coordinator: StudyListNavigation, viewModel: DetailActivityMemberListViewModel) {
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
            memberCountLabel,
            tableView
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        xButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(71)
            make.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(xButton.snp.trailing).offset(24)
            make.centerY.equalTo(xButton)
        }
        
        memberCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(xButton)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = DetailActivityMemberListViewModel.Input(
            didTapXButton: xButton.tapPublisher.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
        
        output.items
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
    }

}

// MARK: - Datasource
extension DetailActivityMemberListViewController {
    private func configureDatasource() {
        datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .memberCell(let member):
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ActivityMemberCell.identifier,
                    for: indexPath) as? ActivityMemberCell
                else { return UITableViewCell() }
                
                cell.configureDetailMemeberCell(item: member)
                return cell
            }
        })
    }
    
    private func updateSnapshot(items: [SectionItem]) {
        guard let datasource = self.datasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        items.forEach { snapshot.appendItems([$0], toSection: .main) }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
