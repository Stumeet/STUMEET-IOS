//
//  StudyMainInvitationPopupViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/27.
//

import UIKit
import SnapKit

class StudyMainInvitationPopupViewController: BaseViewController {

    // MARK: - UIComponents
    private let popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let closeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconClose), for: .normal)
        button.addTarget(self, action: #selector(dismissPopupView), for: .touchUpInside)
        return button
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let textContentContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let textContentInnerContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "링크를 공유하여 최대 50명까지 초대해보세요!"
        return label
    }()
    
    private let actionContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let actionInnerContainerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let copyLinkContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let copyLinkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconLink), for: .normal)
        button.backgroundColor = StumeetColor.primary50.color
        return button
    }()

    private let copyLinkLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "링크 복사"
        return label
    }()
    
    private let emailContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconMail), for: .normal)
        button.backgroundColor = StumeetColor.primary50.color
        return button
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "메일"
        return label
    }()
    private let kakaoTalkContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let kakaoTalkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconKakaotalk), for: .normal)
        button.backgroundColor = .clear
        return button
    }()

    private let kakaoTalkLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.gray300.color
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "카카오톡"
        return label
    }()
    
    // MARK: - Init
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0)
    }
    
    override func setupAddView() {
        view.addSubview(popupContainer)
        popupContainer.addSubview(rootVStackView)
        
        [
            closeContainerView,
            contentImageView,
            textContentContainerView,
            actionContainerView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        closeContainerView.addSubview(closeButton)
        textContentContainerView.addSubview(textContentInnerContainerVStackView)
        actionContainerView.addSubview(actionInnerContainerHStackView)
        
        [
            titleLabel,
            subtitleLabel
        ].forEach { textContentInnerContainerVStackView.addArrangedSubview($0) }
        
        [
            copyLinkContainerVStackView,
            emailContainerVStackView,
            kakaoTalkContainerVStackView
        ].forEach { actionInnerContainerHStackView.addArrangedSubview($0) }
        
        [
            copyLinkButton,
            copyLinkLabel
        ].forEach { copyLinkContainerVStackView.addArrangedSubview($0) }
        
        [
            emailButton,
            emailLabel
        ].forEach { emailContainerVStackView.addArrangedSubview($0) }
        
        [
            kakaoTalkButton,
            kakaoTalkLabel
        ].forEach { kakaoTalkContainerVStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        popupContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        rootVStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.bottom.equalToSuperview().inset(26)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        actionInnerContainerHStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.verticalEdges.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints {
            $0.height.equalTo(contentImageView.snp.width).multipliedBy(121.0 / 316.0)
        }
        
        textContentInnerContainerVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(19)
        }
        
        
        [
            copyLinkButton,
            emailButton,
            kakaoTalkButton
        ].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(56)
            }
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        [
            copyLinkButton,
            emailButton,
            kakaoTalkButton
        ].forEach {
            $0.setRoundCorner()
        }
        
        popupContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        // TODO: API 연동 시 수정
        titleLabel.text = "스터디 이름에 멤버 초대하기!"
        titleLabel.setColorAndFont(to: "스터디 이름", withColor: StumeetColor.gray900.color, withFont: StumeetFont.titleBold.font)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToExpandedState()
    }
    
    // MARK: - Function
    private func animateToExpandedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.1)
            self.popupContainer.transform = .identity
        })
    }
    
    private func animateToCollapsedState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.0)
            self.popupContainer.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }

    @objc func dismissPopupView() {
        animateToCollapsedState()
    }


}
