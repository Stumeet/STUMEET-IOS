//
//  ActivityMemberSettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/13/24.
//

import UIKit

class ActivityMemberSettingViewController: BaseViewController {
    
    // MARK: - Typealias
    
    typealias Section = ActivityMemberSection
    typealias SectionItem = ActivityMemberSectionItem
    
    // MARK: - UIComponents
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        return UILabel().setLabelProperty(text: "참여 멤버", font: StumeetFont.titleMedium.font, color: .gray800)
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "멤버 이름 검색",
            attributes: [NSAttributedString.Key.foregroundColor: StumeetColor.gray400.color])

        textField.backgroundColor = StumeetColor.primary50.color
        textField.layer.cornerRadius = 10
        
        let rightImageView = UIImageView(image: UIImage(named: "search"))
        
        let rightViewContainer = UIView()
        rightViewContainer.frame = CGRect(x: 0, y: 0, width: rightImageView.frame.width, height: rightImageView.frame.height)
        rightImageView.frame = CGRect(x: -24, y: 0, width: rightImageView.frame.width, height: rightImageView.frame.height)
        rightViewContainer.addSubview(rightImageView)
        
        textField.rightView = rightViewContainer
        textField.rightViewMode = .always
        textField.addLeftPadding(24)
        
        return textField
    }()
    
    private let allSelectButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init("전체 선택")
        titleAttr.font = StumeetFont.bodyMedium14.font
        titleAttr.foregroundColor = StumeetColor.gray400.color
        config.attributedTitle = titleAttr
        
        config.image = UIImage(named: "memberUnSelectedButton")
        config.imagePlacement = .leading
        config.imagePadding = 8
        button.configuration = config
        
        return button
    }()
    
    private let memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ActivityMemberCell.self, forCellReuseIdentifier: ActivityMemberCell.identifier)
        tableView.rowHeight = 72
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let completeButton: UIButton = {
        return UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    }()
    
    // MARK: - Properties
    
    private let coordinator: CreateActivityNavigation
    private var datasource: UITableViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Init
    
    init(coordinator: CreateActivityNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatasource()
        
        // FIXME: - ViewModelBinding
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems([SectionItem.memberCell("홍길동1"),
                              SectionItem.memberCell("홍길동2"),
                              SectionItem.memberCell("홍길동3"),
                              SectionItem.memberCell("홍길동4"),
                              SectionItem.memberCell("홍길동5"),
                              SectionItem.memberCell("홍길동6"),
                              SectionItem.memberCell("홍길동7"),
                              SectionItem.memberCell("홍길동8"),
                              SectionItem.memberCell("홍길동9")])
        
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            xButton,
            titleLabel,
            searchTextField,
            allSelectButton,
            memberTableView,
            completeButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.centerY.equalTo(xButton)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.height.equalTo(56)
        }
        
        allSelectButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(searchTextField.snp.bottom).offset(24)
            make.height.equalTo(84)
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(allSelectButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(432)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {

    }
    
}

// MARK: - Datasource

extension ActivityMemberSettingViewController {
    func configureDatasource() {
        datasource = UITableViewDiffableDataSource(tableView: memberTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .memberCell(let name):
                guard let cell =
                        tableView.dequeueReusableCell(
                            withIdentifier: ActivityMemberCell.identifier,
                            for: indexPath
                        ) as? ActivityMemberCell
                else { return UITableViewCell() }
                cell.configureCell(name)
                
                return cell
            }
        })
    }
}
