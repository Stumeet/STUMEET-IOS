//
//  MyStudyGroupListViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit
import SnapKit
import Combine

class MyStudyGroupListViewController: BaseViewController {
    
    // MARK: - UIComponents
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 스터디 그룹"
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
        return label
    }()
    private let studyGroupTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.scrollsToTop = false
        return tableView
    }()
    
    // MARK: - Properties
    private weak var coordinator: MyStudyGroupListNavigation!
    private let viewModel: MyStudyGroupListViewModel
    private var studyGroupDataSource: UITableViewDiffableDataSource<MyStudyGroupListSection, StudyGroup>?
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    init(coordinator: MyStudyGroupListNavigation,
         viewModel: MyStudyGroupListViewModel
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

        // TODO: 네비 및 탭바 속성 설정 위치 재구성
        let naviBarAppearance = UINavigationBarAppearance()
        let tabBarAppearance = UITabBarAppearance()
        naviBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = naviBarAppearance
        tabBarController?.tabBar.standardAppearance = tabBarAppearance
    }
    
    override func setupAddView() {
        view.addSubview(studyGroupTableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
        navigationItem.rightBarButtonItem = makeBarButtonItem("tabler_plus")
    }
    
    override func setupConstaints() {
        studyGroupTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupRegister() {
        studyGroupTableView.registerCell(MyStudyGroupListTableViewCell.self)
    }
    
    private func setupDelegate() {
        studyGroupTableView.delegate = self
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegister()
        setupDelegate()
        configureDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send()
    }
    
    override func bind() {
        // MARK: - Input
        let input = MyStudyGroupListViewModel.Input(
            viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher()
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.studyGroupDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
    }
    
    // MARK: - Function
    private func makeBarButtonItem(_ imageName: String) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        return UIBarButtonItem(customView: button)
    }
}

extension MyStudyGroupListViewController:
    UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.goToStudyMain()
    }
    
    // MARK: - DataSource
    private func configureDatasource() {
        studyGroupDataSource = UITableViewDiffableDataSource(
            tableView: studyGroupTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(MyStudyGroupListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            }
        )
    }
    
    private func updateSnapshot(items: [StudyGroup]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyStudyGroupListSection, StudyGroup>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.studyGroupDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
