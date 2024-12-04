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
    private let didTapAlarmButtonSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init( coordinator: HomeNavigation ) {
        self.coordinator = coordinator
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
        if section == 0 { return 1 }
        return 0
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
        guard let cell = tableView.dequeue(HomeHeaderTableViewCell.self, for: indexPath)
        else { return UITableViewCell() }
        cell.configureCell()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
