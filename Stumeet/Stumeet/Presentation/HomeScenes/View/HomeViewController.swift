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
        return tableView
    }()
    
    private var headerTapBarView: HeaderTapBarView = {
        let tapbarView =  HeaderTapBarView(
            options: HomeHeaderTapBarViewType.allCases.map { ($0.title, $0.id) },
            initSelectedIndex: HomeHeaderTapBarViewType.task.id
        )
        
        tapbarView.backgroundColor = .white
        return tapbarView
    }()
    
    
    // MARK: - Properties
    private weak var coordinator: HomeNavigation!
    private let viewModel: HomeViewModel
    
    private var headerDataSource: [String] = ["테스트"]
    private var activityDataSource: [HomeActivityItem] = [
        HomeActivityItem(
            activity: Activity(
                id: 0,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 1,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 2,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 3,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 4,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 5,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 6,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 7,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        ),
        HomeActivityItem(
            activity: Activity(
                id: 8,
                tag: .homework,
                title: "제목",
                content: "캠스터디 교재 1장 45.p ~ 47.p 2번까지 풀고 풀",
                startTiem: "2024-04-22T00:00:00",
                endTime: "2024-04-23T00:00:00",
                place: "강남",
                name: "타이틀",
                day: "2024-11-25T09:56:21.296888",
                status: .attendance
            )
        )
    ]
    
    private let didTapAlarmButtonSubject = PassthroughSubject<Void, Never>()
    
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
            didTapAlarmButton: didTapAlarmButtonSubject.eraseToAnyPublisher()
        )
                
        // MARK: - Output
        let output = viewModel.transform(input: input)
 
        output.presentToAlarmVC
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.startNotificationCoordinator )
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Function
    private func makeBarButtonItem(image: ImageResource, action: UIAction) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(resource: image)
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
    
        return UIBarButtonItem(customView: button)
    }
}

extension HomeViewController:
    UITableViewDataSource,
    UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return headerDataSource.count }
        return activityDataSource.count
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
            guard let cell = tableView.dequeue(HomeHeaderTableViewCell.self, for: indexPath)
            else { return UITableViewCell() }
            cell.configureCell()
            return cell
        } else {
            guard let cell = tableView.dequeue(HomeActivityTableViewCell.self, for: indexPath),
                  let activityData = activityDataSource[safe: indexPath.row]
            else { return UITableViewCell() }
            cell.configureCell(data: activityData)
            return cell
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
        
        if currentScrollPosition >= firstSectionHeaderPosition {
            headerTapBarView.adjustSeparatorAlpha(alpha: max(0, min(1, alphaValue + 0.2)))
            
        } else {
            headerTapBarView.adjustSeparatorAlpha(alpha: 0)
        }
    }
}
