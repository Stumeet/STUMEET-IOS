//
//  HomeViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/03.
//

import UIKit
import SnapKit
import Combine

class HomeViewController: BaseViewController {
    
    // MARK: - UIComponents
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "로고자리"
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.registerCell(HomeHeaderTableViewCell.self)
        tableView.registerCell(HomeActivityTableViewCell.self)
        tableView.registerCell(HomeNoticeTableViewCell.self)
        return tableView
    }()
    
    private lazy var headerTapBarView: HeaderTapBarView = {
        let tapbarView =  HeaderTapBarView(
            options: HomeHeaderTapBarViewType.allCases.map { ($0.title, $0.id) },
            initSelectedIndex: HomeHeaderTapBarViewType.task.id
        )
        tapbarView.delegate = self
        tapbarView.backgroundColor = .white
        return tapbarView
    }()
    
    
    // MARK: - Properties
    private weak var coordinator: HomeNavigation!
    private let viewModel: HomeViewModel
    
    private var headerDataSource: HomeHeaderActivityItem?
    private var activityDataSource: [HomeActivityItem] = []
    private var noticeDataSource: [HomeNoticeItem] = []
    
    private let didTapAlarmButtonSubject = PassthroughSubject<Void, Never>()
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    private let didTapHeadderTapBarButtonSubject = PassthroughSubject<HomeHeaderTapBarViewType, Never>()
    private let didReachTableBottomSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(
        coordinator: HomeNavigation,
        viewModel: HomeViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        view.addSubview(tableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
        navigationItem.rightBarButtonItem = makeBarButtonItem(
            image: .Home.tablerBell,
            action: UIAction { [weak self] _ in
                guard let self else { return }
                didTapAlarmButtonSubject.send()
            }
        )
    }
    
    override func setupConstaints() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = HomeViewModel.Input(
            loadData: loadDataSubject.eraseToAnyPublisher(),
            didTapAlarmButton: didTapAlarmButtonSubject.eraseToAnyPublisher(),
            didTapHeadderTapBarButton: didTapHeadderTapBarButtonSubject.eraseToAnyPublisher(),
            didReachTableBottom: didReachTableBottomSubject.eraseToAnyPublisher()
        )
                
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.headerActivityDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateHeaderActivityView)
            .store(in: &cancellables)
        
        output.activityDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateActivityView)
            .store(in: &cancellables)
        
        output.noticeDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateNoticeView)
            .store(in: &cancellables)
        
        output.presentToAlarmVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.startNotificationCoordinator )
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataSubject.send()
    }
    
    // MARK: - Function
    private func makeBarButtonItem(image: ImageResource, action: UIAction) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(resource: image)
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
    
        return UIBarButtonItem(customView: button)
    }
    
    private func updateHeaderActivityView(data: HomeHeaderActivityItem) {
        headerDataSource = data
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func updateActivityView(data: [HomeActivityItem]) {
        activityDataSource = data
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    private func updateNoticeView(data: [HomeNoticeItem]) {
        noticeDataSource = data
        tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
}

extension HomeViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    HeaderTapBarViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return headerDataSource == nil ? 0 : 1 }
        switch viewModel.currentTap.value {
        case .task: return activityDataSource.count
        case .notice: return noticeDataSource.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        return headerTapBarView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 1 else { return 0 }
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeue(HomeHeaderTableViewCell.self, for: indexPath),
                  let headerDataSource
            else { return UITableViewCell() }
            cell.configureCell(data: headerDataSource)
            return cell
        } else {
            
            switch viewModel.currentTap.value {
            case .task:
                guard let cell = tableView.dequeue(HomeActivityTableViewCell.self, for: indexPath),
                      let activityData = activityDataSource[safe: indexPath.row]
                else { return UITableViewCell() }
                cell.configureCell(data: activityData)
                return cell
            case .notice:
                guard let cell = tableView.dequeue(HomeNoticeTableViewCell.self, for: indexPath),
                      let noticeData = noticeDataSource[safe: indexPath.row]
                else { return UITableViewCell() }
                cell.configureCell(data: noticeData)
                return cell
            default: return UITableViewCell()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        
        // 첫 번째 섹션의 헤더 위치 계산
        let firstSectionHeaderRect = tableView.rectForHeader(inSection: 1)
        let firstSectionHeaderPosition = firstSectionHeaderRect.origin.y
        
        let currentScrollPosition = scrollView.contentOffset.y
        let alphaValue = (currentScrollPosition - firstSectionHeaderPosition) / firstSectionHeaderPosition
        let threshold = max(0, (scrollView.contentSize.height) * 0.3)
        
        if currentScrollPosition > threshold { didReachTableBottomSubject.send() }
        
        if currentScrollPosition >= firstSectionHeaderPosition {
            headerTapBarView.adjustSeparatorAlpha(alpha: max(0, min(1, alphaValue + 0.2)))
            
        } else {
            headerTapBarView.adjustSeparatorAlpha(alpha: 0)
        }
    }
    
    // MARK: - HeaderTapBarViewDelegate
    func didTapAction(_ button: HeaderTapBarView.RadioButton) {
        guard let tapType = HomeHeaderTapBarViewType(rawValue: button.id) else { return }
        didTapHeadderTapBarButtonSubject.send(tapType)
    }
}
