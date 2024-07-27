//
//  StudyMainViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/13.
//

import UIKit
import SnapKit
import Combine
import Kingfisher

// TODO: API 연동 시 수정
enum StudyMainViewCellStyle {
    case activity
    case detailInfo
}

class StudyMainViewController: BaseViewController {
    
    // MARK: - UIComponents
    private lazy var menuOpenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .StudyGroupMain.iconHamburgerMenu), for: .normal)
        button.addTarget(self, action: #selector(menuOpenButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var newActivityFloatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .StudyGroupMain.floatingPlus), for: .normal)
        button.setImage(UIImage(resource: .StudyGroupMain.floatingPlus), for: .disabled)
        button.backgroundColor = StumeetColor.primary700.color
        button.setShadow()
        return button
    }()
    
    private lazy var praiseReminderFloatingPopupView: StudyMainPraiseReminderPopupView = {
        let popupView = StudyMainPraiseReminderPopupView()
        popupView.delegate = self
        return popupView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let sectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray50.color
        return view
    }()
    
    private let sectionHeaderSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray100.color
        return view
    }()
    
    private let sectionHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleSemibold.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    private lazy var detailInfoOpenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .StudyGroupMain.iconArrowDown), for: .normal)
        button.addTarget(self, action: #selector(detailInfoOpenButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        // 스크롤 뷰의 내용이 자동으로 안전 영역이나 네비게이션 바 등의 UI 요소에 의해 조정되지 않도록함
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.registerCell(StudyMainDetailInfoTableViewCell.self)
        tableView.registerCell(StudyMainActivityTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Properties
    private weak var coordinator: MyStudyGroupListNavigation!
    private let viewModel: StudyMainViewModel
    private let loadStudyGroupDetailData = PassthroughSubject<Void, Never>()
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private lazy var tableHeaderHeight: CGFloat = (screenWidth * 0.542).rounded() // 디바이스 넓이 * 크기 비율
    private var constPopupBottom: Constraint!
    // TODO: API 연동 시 수정
    private var activityList: [StudyMainViewCellStyle] = [.activity, .activity, .activity, .activity, .activity, .activity]
    private var detailInfoData: [StudyMainViewDetailInfoItem] = []
    private var isActivity = true
    

    // MARK: - Init
    init(coordinator: MyStudyGroupListNavigation,
         viewModel: StudyMainViewModel
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
        navigationController?.setupBarAppearance(backgroundColor: .white.withAlphaComponent(0), backButtonColor: .white)
        tabBarController?.setupBarAppearance()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuOpenButton)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 72, right: 0) // headerView의 공간 확보를 위해 헤더 높이 만큼 inset 부여
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight) // 첫 상단 스크롤 시작을 위해 inset 준만큼 위치 변경
    }
    
    override func setupAddView() {
        view.addSubview(tableView)
        view.addSubview(newActivityFloatingButton)
        view.addSubview(praiseReminderFloatingPopupView)
        
        tableView.addSubview(headerView)
        headerView.addSubview(headerImageView)
 
        sectionHeaderView.addSubview(sectionHeaderTitleLabel)
        sectionHeaderView.addSubview(detailInfoOpenButton)
        sectionHeaderView.addSubview(sectionHeaderSeparatorView)
    }
    
    override func setupConstaints() {
        praiseReminderFloatingPopupView.snp.makeConstraints {
            constPopupBottom = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10).constraint
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        newActivityFloatingButton.snp.makeConstraints {
            $0.trailing.equalTo(praiseReminderFloatingPopupView)
            $0.bottom.equalTo(praiseReminderFloatingPopupView.snp.top).offset(-16).priority(.high)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        newActivityFloatingButton.snp.makeConstraints {
            $0.size.equalTo(72)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sectionHeaderTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalTo(detailInfoOpenButton.snp.leading)
            $0.centerY.equalToSuperview()
        }
        
        detailInfoOpenButton.snp.makeConstraints {
            $0.size.equalTo(48)
            $0.centerX.equalTo(sectionHeaderView.snp.right).inset(36)
            $0.centerY.equalToSuperview()
        }
        
        sectionHeaderSeparatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = StudyMainViewModel.Input(
            loadStudyGroupDetailData: loadStudyGroupDetailData.eraseToAnyPublisher()
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.studyGroupDetailHeaderDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateHeaderView)
            .store(in: &cancellables)
        
        output.studyGroupDetailInfoDataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateInfoView)
            .store(in: &cancellables)

    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        newActivityFloatingButton.setRoundCorner()
        // TODO: API 연동 시 수정
        loadStudyGroupDetailData.send()
    }
    
    // MARK: - Function
    private func updateHeaderView(data: StudyMainViewHeaderItem?) {
        guard let data = data else { return }
        sectionHeaderTitleLabel.text = data.title
        
        let url = URL(string: data.thumbnailImageUrl)
        headerImageView.kf.setImage(with: url)
    }
    
    private func updateInfoView(data: StudyMainViewDetailInfoItem?) {
        guard let data = data else { return }
        detailInfoData = [data]
    }
    
    private func updateHeaderView() {
        var tableWidth = 0.0
        
        // viewDidLoad 에서는 테이블의 레이아웃값이 없기에 systemLayoutSizeFitting 활용
        if tableView.bounds.width == 0 {
            tableWidth = tableView.systemLayoutSizeFitting(UIScreen.main.bounds.size).width
        } else {
            tableWidth = tableView.bounds.width
        }
        
        // 테이블뷰가 기준이기에 y값은 음수
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableWidth, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y // 첫 위치가  -tableHeaderHeight 인걸 생각하면 이 값이 맞음
            headerRect.size.height = -tableView.contentOffset.y // 하단으로 당기면 contentOffset은 음수 이기에 양수 변환을 위해 음수화
        } else {
            // viewForHeaderInSection의 위치 때문에 contentInset도 실시간으로 변경해줘야함
            tableView.contentInset.top = max(-tableView.contentOffset.y, view.safeAreaInsets.top)
        }
        
        headerView.frame = headerRect
    }
    
    private func animateButtonImage(to image: UIImage, for button: UIButton) {
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            button.setImage(image, for: .normal)
        })
    }
    
    private func animateControlAlpha(for control: UIView, isHidden: Bool) {
        control.isUserInteractionEnabled = false
        UIView.animate(
            withDuration: 0.3,
            animations: {
                control.alpha = isHidden ? 0 : 1
            },
            completion: { _ in
                control.isUserInteractionEnabled = true
            })
    }
    
    // TODO: API 연동 시 수정
    private func reloadTableView() {
        isActivity.toggle()
        animateButtonImage(to: UIImage(resource: isActivity ? .StudyGroupMain.iconArrowDown : .StudyGroupMain.iconArrowUp), for: detailInfoOpenButton)
        animateControlAlpha(for: newActivityFloatingButton, isHidden: !isActivity)
        animateControlAlpha(for: praiseReminderFloatingPopupView, isHidden: !isActivity)
        
        detailInfoOpenButton.isEnabled = false

        var indexPaths = [IndexPath]()
        
        for index in 0..<activityList.count {
            let indexPath = IndexPath(row: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        tableView.performBatchUpdates({
            if isActivity {
                tableView.insertRows(at: indexPaths, with: .bottom)
                tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            } else {
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                tableView.deleteRows(at: indexPaths, with: .fade)
            }
            
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            detailInfoOpenButton.isEnabled = true
        })
    }
    
    // TODO: API 연동 시 수정
    @objc func menuOpenButtonTapped(_ sender: UIButton) {
        coordinator.presentToSideMenu(from: self)
    }
    
    // TODO: API 연동 시 수정
    @objc func detailInfoOpenButtonTapped(_ sender: UIButton) {
        reloadTableView()
    }
}

extension StudyMainViewController:
    UITableViewDataSource,
    UITableViewDelegate,
    StudyMainPraiseReminderPopupViewDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isActivity ? activityList.count : detailInfoData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    // TODO: API 연동 시 수정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if isActivity {
            guard let cell = tableView.dequeue(StudyMainActivityTableViewCell.self, for: indexPath)
//                  let activityData = activityList[safe: indexPath.row]
            else { return UITableViewCell() }
            
            switch indexPath.row {
            case 0:
                cell.configureCell(style: .notice)
                
            case 1:
                cell.configureCell(style: .activityFirstCell)
            default:
                cell.configureCell(style: .normal)
            }
            
            return cell
        } else {
            
            guard let cell = tableView.dequeue(StudyMainDetailInfoTableViewCell.self, for: indexPath),
                  let activityData = detailInfoData[safe: indexPath.row]
            else { return UITableViewCell() }
            cell.onHeightChanged = {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            cell.configureCell(data: activityData)
            return cell
            
        }
    }
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        
        let offsetY = scrollView.contentOffset.y + tableHeaderHeight
        let maxOffsetY: CGFloat = 100

        // 비율 계산 (0.0 ~ 1.0)
        let ratio = min(max(offsetY / maxOffsetY, 0.0), 1.0)
        
        // 색상 변화 계산 (흰색에서 검정색으로)
        let startColor = UIColor.white
        let endColor = StumeetColor.gray800.color
        let barButtonColor = startColor.between(endColor, percentage: ratio)
        let barColor = startColor.withAlphaComponent(ratio)
        
        menuOpenButton.tintColor = barButtonColor
        navigationController?.updateBarColor(backgroundColor: barColor, backButtonColor: barButtonColor)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    // MARK: - StudyMainPraiseReminderPopupViewDelegate
    func closeButtonAction() {
        constPopupBottom.update(inset: -praiseReminderFloatingPopupView.frame.height - view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            var initialTransform = CATransform3DIdentity
            initialTransform = CATransform3DScale(initialTransform, 0.1, 0.1, 1)
            initialTransform = CATransform3DTranslate(
                initialTransform,
                0,
                praiseReminderFloatingPopupView.frame.height + view.safeAreaInsets.bottom,
                0.3
            )

            praiseReminderFloatingPopupView.layer.transform = initialTransform
            praiseReminderFloatingPopupView.alpha = 0
            view.layoutIfNeeded()
        })
    }
}
