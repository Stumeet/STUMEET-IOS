//
//  NotificationViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit
import SnapKit
import Combine

class NotificationViewController: BaseViewController {
    // MARK: - UIComponents
    private lazy var xButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(resource: .xMark),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        barButton.tintColor = StumeetColor.gray800.color
        
        return barButton
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "알림"
        return label
    }()
    
    private lazy var notificationTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 77
        tableView.registerCell(NotificationListTableViewCell.self)
        return tableView
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Properties
    private weak var coordinator: NotificationNavigation!
    private let viewModel: NotificationViewModel
    private var notificationDataSource: UITableViewDiffableDataSource<NotificationListSection, NotificationListItem>?
    private let loadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(
        coordinator: NotificationNavigation,
        viewModel: NotificationViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
        self.navigationController?.setupBarAppearance()
    }
    
    override func setupAddView() {
        view.addSubview(notificationTableView)
        
        navigationItem.leftBarButtonItem = xButton
        navigationItem.titleView = titleLabel
    }
    
    override func setupConstaints() {
        notificationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = NotificationViewModel.Input(
            loadData: loadDataSubject.eraseToAnyPublisher()
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.notificationDataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.updateSnapshot(items: items)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
        loadDataSubject.send()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        notificationTableView.contentInset.bottom = view.safeAreaInsets.bottom
    }
    
    // MARK: - Function
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        coordinator.dimiss()
    }
}

extension NotificationViewController {
    // MARK: - DataSource
    private func configureDatasource() {
        notificationDataSource = UITableViewDiffableDataSource(
            tableView: notificationTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(NotificationListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            }
        )
    }
    
    private func updateSnapshot(items: [NotificationListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<NotificationListSection, NotificationListItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.notificationDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
