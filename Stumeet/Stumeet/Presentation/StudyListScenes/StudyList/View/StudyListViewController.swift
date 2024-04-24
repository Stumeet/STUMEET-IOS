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
    private let navigationTitleLabel = UILabel()
    private let studyGroupTableView = UITableView()
    private var contextMenu = StudyGroupListContextMenuView()
    
    // MARK: - Properties
    private weak var coordinator: StudyListCoordinator!
    private var studyGroupDataSource: UITableViewDiffableDataSource<StudyGroupSection, StudyGroup>?
    
    // MARK: - Init
    init(coordinator: StudyListCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        
        navigationTitleLabel.text = "내 스터디 그룹"
        navigationTitleLabel.font = StumeetFont.titleMedium.font
        navigationTitleLabel.textColor = StumeetColor.gray800.color
        navigationTitleLabel.numberOfLines = 0
                
        studyGroupTableView.separatorStyle = .none
        studyGroupTableView.backgroundColor = .white
        studyGroupTableView.scrollsToTop = false
        
        contextMenu.addItem(image: UIImage(named: "tabler_door-exit"), title: "나가기")
        contextMenu.addItem(image: UIImage(named: "tabler_message-report"), title: "신고하기")
        contextMenu.isHidden = true
        
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
        view.addSubview(contextMenu)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
        navigationItem.rightBarButtonItem = makeBarButtonItem("tabler_plus")
    }
    
    override func setupConstaints() {
        studyGroupTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contextMenu.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
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
        configureDatasource()
        setupGesture()
        setupDelegate()
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
        hideContextMenu()
    }
    
    // MARK: - Function
    private func makeBarButtonItem(_ imageName: String) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(named: imageName)
        button.setImage(image, for: .normal)
        return UIBarButtonItem(customView: button)
    }
    
    private func hideContextMenu() {
        guard !contextMenu.isVisiblyHidden else { return }
        contextMenu.isVisiblyHidden = true
    }
    
    private func toggleContextMenu(near button: UIView) {
        guard contextMenu.isVisiblyHidden else {
            hideContextMenu()
            return
        }
        
        let menuHeight = contextMenu.bounds.size.height
        let menuWidth = contextMenu.bounds.size.width
        let buttonFrame = studyGroupTableView.convert(button.frame, from: button.superview)
        let bottomCoordinate = buttonFrame.origin.y + menuHeight
        
        if bottomCoordinate > studyGroupTableView.contentOffset.y + studyGroupTableView.bounds.size.height {
            contextMenu.layer.anchorPoint = CGPoint(x: 1.0, y: 1)
        } else {
            contextMenu.layer.anchorPoint = CGPoint(x: 1.0, y: 0)
        }
        
        contextMenu.snp.remakeConstraints {
            // !IMP: anchorPoint: (x: 0.5, y: 0.5) -> (x: 1.0, y: 0)
            $0.top.equalTo(button.snp.top).offset(-(menuHeight / 2))
            $0.trailing.equalTo(button.snp.leading).offset((menuWidth / 2) + 8)
        }

        contextMenu.isVisiblyHidden = false
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        hideContextMenu()
    }
}

extension StudyListViewController:
    StudyGroupListTableViewCellDelegate,
    UITableViewDelegate {
    // MARK: - StudyGroupListTableViewCellDelegate
    func didTapMoreButton(button: UIView) {
        toggleContextMenu(near: button)
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideContextMenu()
    }
    
    // MARK: - DataSource
    private func configureDatasource() {
        studyGroupDataSource = UITableViewDiffableDataSource(
            tableView: studyGroupTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(StudyGroupListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell()
                cell.delegate = self
                return cell
            }
        )
    }
}
