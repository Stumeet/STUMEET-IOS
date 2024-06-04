//
//  StudyMainPraiseReminderPopupView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/29.
//

import UIKit
import SnapKit

class StudyMainPraiseReminderPopupView: UIView {
    
    // MARK: - UIComponents
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .StudyGroupMain.iconGrape)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let contentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 7
        return stackView
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.primary700.color
        label.text = "이번주 포도알 칭찬을 하지 않았어요."
        return label
    }()
    
    private let contentSubtitleHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let contentSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.primary600.color
        label.text = "멤버 명단으로 가기"
        return label
    }()
    
    private let subtitleSymbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .StudyGroupMain.iconChevronLeft)
        return imageView
    }()
    
    private lazy var closeButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        buttonConfiguration.image = UIImage(resource: .StudyGroupMain.iconClose16Px)
        
        let button = UIButton(configuration: buttonConfiguration)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: StudyMainPraiseReminderPopupViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        setupStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = StumeetColor.primary100.color
        layer.cornerRadius = 16
        setShadow()
    }
    
    private func setupAddView() {
        addSubview(symbolImageView)
        addSubview(contentVStackView)
        addSubview(closeButton)
        
        [
            contentTitleLabel,
            contentSubtitleHStackView
        ].forEach { contentVStackView.addArrangedSubview($0) }
        
        
        [
            contentSubtitleLabel,
            subtitleSymbolImageView
        ].forEach { contentSubtitleHStackView.addArrangedSubview($0) }
    }
    
    private func setupConstaints() {
        symbolImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.left.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview().inset(21)
        }
        
        contentVStackView.snp.makeConstraints {
            $0.left.equalTo(symbolImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(5)
            $0.left.greaterThanOrEqualTo(contentVStackView.snp.right).offset(0)
        }
    }
    
    @objc func closeButtonTapped(_ sender: UIButton) {
        delegate?.closeButtonAction()
    }
}

protocol StudyMainPraiseReminderPopupViewDelegate: AnyObject {
    func closeButtonAction()
}
