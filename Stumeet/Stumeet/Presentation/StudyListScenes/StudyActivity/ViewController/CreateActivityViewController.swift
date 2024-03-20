//
//  CreateActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/18/24.
//

import UIKit

final class CreateActivityViewController: BaseViewController {

    // MARK: - UIComponents
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
    
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xMark"), for: .normal)
        
        return button
    }()
    
    private let topLabel: UILabel = {
        return UILabel().setLabelProperty(text: "활동 생성", font: StumeetFont.titleMedium.font, color: nil)
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.isEnabled = false
        button.setTitleColor(StumeetColor.gray400.color, for: .disabled)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        
        config.attributedTitle = AttributedString("자유", attributes: AttributeContainer([.foregroundColor: UIColor.black]))
        config.image = UIImage(named: "greenDownPolygon")
        config.imagePlacement = .trailing
        
        button.configuration = config
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.layer.borderColor = StumeetColor.primary700.color.cgColor
        
        return button
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 이름"
        textField.setPlaceholder(font: .subTitleMedium2, color: .gray600)
        
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력하세요"
        textView.textColor = StumeetColor.gray300.color
        textView.font = StumeetFont.bodyMedium15.font
    
        return textView
        
    }()
    
    private let bottomView = UIView()
    
    private let imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addImageButton"), for: .normal)
        
        return button
    }()
    
    private let noticeLabel: UILabel = {
        return UILabel().setLabelProperty(text: "공지 등록", font: StumeetFont.bodyMedium14.font, color: .gray500)
    }()
    
    private let noticeSwitch = UISwitch()
    
    // MARK: - Properties
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp
    
    override func viewDidLayoutSubviews() {
        bottomView.layer.addBorder([.top, .bottom], color: StumeetColor.gray100.color, width: 1)
        contentTextView.layer.addBorder([.top], color: StumeetColor.gray100.color, width: 1)
        categoryButton.configuration?.imagePadding =  269 * categoryButton.frame.width / 380
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        noticeSwitch.transform = CGAffineTransform(scaleX: 36 / 51, y: 20 / 31)
    }
    
    override func setupAddView() {
        
        [
            imageButton,
            noticeLabel,
            noticeSwitch
        ]   .forEach { bottomView.addSubview($0) }
        
        [
            xButton,
            topLabel,
            nextButton,
            categoryButton,
            titleTextField,
            contentTextView,
            bottomView
        ]   .forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
    }
    
    override func setupConstaints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(71)
        }
        
        topLabel.snp.makeConstraints { make in
            make.leading.equalTo(xButton.snp.trailing).offset(24)
            make.top.equalTo(xButton)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(topLabel)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(xButton.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.height.equalTo(520)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(contentTextView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(64)
        }
        imageButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        noticeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        noticeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(noticeSwitch.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        
    }
}
