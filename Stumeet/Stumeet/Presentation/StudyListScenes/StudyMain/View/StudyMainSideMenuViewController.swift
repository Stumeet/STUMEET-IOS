//
//  StudyMainSideMenuViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/18.
//

import UIKit
import SnapKit

// TODO: API 연동 시 수정
enum StudyMainMenuSection: Hashable {
    case main
}

struct StudyMainMenu: Hashable {
    let id: Int
    let title: String
    let symbolImage: UIImage
}

class StudyMainSideMenuViewController: BaseViewController {

    // MARK: - UIComponents
    private lazy var sideMenuContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(self.handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        return view
    }()
    
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleSemibold.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
        // TODO: API 연동 시 수정
        label.text = "자바를 자바"
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        return view
    }()
    
    private let footerContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var addMemberButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .StudyGroupMain.usersPlus), for: .normal)
        button.addTarget(self, action: #selector(invitationPopupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var exitStudyGroupButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .StudyGroupMain.doorEnter), for: .normal)
        button.addTarget(self, action: #selector(exitPopupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private weak var coordinator: MyStudyGroupListNavigation!
    private let screenWidth = UIScreen.main.bounds.size.width
    private lazy var deviceWidthRatio = screenWidth * 0.7 // 디바이스 너비의 70%를 계산
    private var menuDataSource: UITableViewDiffableDataSource<StudyMainMenuSection, StudyMainMenu>?
    
    // MARK: - Init
    init(coordinator: MyStudyGroupListNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func setupAddView() {
        view.addSubview(sideMenuContainer)
        
        sideMenuContainer.addSubview(rootVStackView)
        
        [
            headerView,
            separatorView,
            menuTableView,
            footerView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        headerView.addSubview(headerTitleLabel)
        footerView.addSubview(footerContentHStackView)
        
        [
            addMemberButton,
            exitStudyGroupButton
        ].forEach { footerContentHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        sideMenuContainer.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(deviceWidthRatio)
        }
        
        rootVStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        footerContentHStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupRegister() {
        menuTableView.registerCell(StudyMainMenuTableViewCell.self)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegister()
        configureDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sideMenuContainer.transform = CGAffineTransform(translationX: deviceWidthRatio, y: 0)
        
        // TODO: API 연결 시 수정
        var snapshot = NSDiffableDataSourceSnapshot<StudyMainMenuSection, StudyMainMenu>()
        snapshot.appendSections([.main])
        snapshot.appendItems([StudyMainMenu(id: 0, title: "공지", symbolImage: UIImage(resource: .StudyGroupMain.pinned)),
                              StudyMainMenu(id: 1, title: "일정", symbolImage: UIImage(resource: .StudyGroupMain.calendarSmile)),
                              StudyMainMenu(id: 2, title: "활동", symbolImage: UIImage(resource: .StudyGroupMain.messageChatbot)),
                              StudyMainMenu(id: 3, title: "멤버", symbolImage: UIImage(resource: .StudyGroupMain.users))])
        
        guard let datasource = self.menuDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToExpandedState()
    }
    
    // FIXME: - 활동으로 화면 전환을 위해 임시로 작성합니다.
    
    override func bind() {
        menuTableView.didSelectRowPublisher
            .filter { $0.item == 2 }
            .map { _ in }
            .sink(receiveValue: coordinator.goToStudyActivityList)
            .store(in: &cancellables)
    }
    
    // MARK: - Function
    private func animateToExpandedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.1)
            self.sideMenuContainer.transform = .identity
        })
    }
    
    private func animateToCollapsedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.0)
            self.sideMenuContainer.transform = CGAffineTransform(translationX: self.deviceWidthRatio, y: 0)
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .changed:
            // 이동 거리가 화면의 0% ~ 70% 사이로 제한
            let limitedX = max(0, min(sideMenuContainer.transform.tx + translation.x, deviceWidthRatio))
            
            sideMenuContainer.transform = CGAffineTransform(translationX: limitedX, y: 0)
            
            // 제스처의 이동 거리 초기화: 연속적인 이동 거리 처리를 위해
            recognizer.setTranslation(CGPoint.zero, in: view)
            
        case .ended, .cancelled:
            if sideMenuContainer.transform.tx >= deviceWidthRatio * 0.1 {
                animateToCollapsedState()
            } else {
                animateToExpandedState()
            }
            
        default:
            break
        }
    }
    
    // TODO: API 연동 시 수정
    @objc func dismissSideMenu() {
        animateToCollapsedState()
    }
    
    @objc func exitPopupButtonTapped(_ sender: UIButton) {
        coordinator.presentToExitPopup(from: self)
    }
    
    @objc func invitationPopupButtonTapped(_ sender: UIButton) {
        coordinator.presentToInvitationPopup(from: self)
    }
}

extension StudyMainSideMenuViewController:
    UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.sideMenuContainer) == false else { return false }
        return true
    }

    // MARK: - DataSource
    private func configureDatasource() {
        menuDataSource = UITableViewDiffableDataSource(
            tableView: menuTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(StudyMainMenuTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            }
        )
    }
    
}
