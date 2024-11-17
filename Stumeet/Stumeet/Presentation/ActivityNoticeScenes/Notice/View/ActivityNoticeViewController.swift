//
//  ActivityNoticeViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import SnapKit
import Combine

class ActivityNoticeViewController: BaseViewController {
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
    
    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "공지"
        return label
    }()
    
    private lazy var activityNoticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCell(StudyMainActivityTableViewCell.self)
        return tableView
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Properties
    private weak var coordinator: ActivityNoticeNavigation!
    private let viewModel: ActivityNoticeViewModel
    private var activityNoticeDataSource: [StudyMainViewActivityItem] = []
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    private let tableReachedBottomSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(
        coordinator: ActivityNoticeNavigation,
        viewModel: ActivityNoticeViewModel
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
        view.addSubview(activityNoticeTableView)
        
        [
            titleLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        navigationItem.leftBarButtonItem = xButton
        navigationItem.titleView = titleStackView
    }
    
    override func setupConstaints() {
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        activityNoticeTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = ActivityNoticeViewModel.Input(
            loadData: loadDataSubject.eraseToAnyPublisher(),
            reachedTableViewBottom: tableReachedBottomSubject.eraseToAnyPublisher()
        )
                
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.activityNoticeDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateActivityView)
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataSubject.send()
    }
    
    // MARK: - Function
    private func updateActivityView(data: [StudyMainViewActivityItem]) {
        activityNoticeDataSource = data
        activityNoticeTableView.reloadData()
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        coordinator.dimiss()
    }
}

extension ActivityNoticeViewController:
    UIAdaptivePresentationControllerDelegate,
    UITableViewDataSource,
    UITableViewDelegate {
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        coordinator.dimiss()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityNoticeDataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(StudyMainActivityTableViewCell.self, for: indexPath),
              let activityData = activityNoticeDataSource[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configureCell(data: activityData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yDelta = scrollView.contentOffset.y
        let threshold = max(0, (scrollView.contentSize.height) * 0.3)
        
        if yDelta > threshold { tableReachedBottomSubject.send() }
    }
}
