//
//  StudyListViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit
import SnapKit

// TODO: API 연동 시 수정
enum StudyGroupSection: Hashable {
    case main
}

struct StudyGroup: Hashable {
    let id: Int
}

class StudyListViewController: BaseViewController {
    
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
    private weak var coordinator: StudyListNavigation!
    private var studyGroupDataSource: UITableViewDiffableDataSource<StudyGroupSection, StudyGroup>?
    
    // MARK: - Init
    init(coordinator: StudyListNavigation) {
        self.coordinator = coordinator
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
        studyGroupTableView.registerCell(StudyGroupListTableViewCell.self)
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
        // TODO: API 연결 시 수정
        var snapshot = NSDiffableDataSourceSnapshot<StudyGroupSection, StudyGroup>()
        snapshot.appendSections([.main])
        snapshot.appendItems([StudyGroup(id: 0),
                              StudyGroup(id: 1),
                              StudyGroup(id: 2),
                              StudyGroup(id: 3),
                              StudyGroup(id: 4),
                              StudyGroup(id: 5),
                              StudyGroup(id: 6),
                              StudyGroup(id: 7),
                              StudyGroup(id: 8)])
        
        guard let datasource = self.studyGroupDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Function
    private func makeBarButtonItem(_ imageName: String) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        return UIBarButtonItem(customView: button)
    }
}

extension StudyListViewController:
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
                guard let cell = tableView.dequeue(StudyGroupListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            }
        )
    }
}
