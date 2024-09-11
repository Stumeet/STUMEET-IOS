//
//  StudyMemberComplimentPopupViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/10.
//

import UIKit
import SnapKit
import Combine

class StudyMemberComplimentPopupViewController: BaseViewController {

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
        button.setImage(UIImage(resource: .StudyGroupMain.iconClose), for: .normal)
        button.addTarget(self, action: #selector(dismissPopupView), for: .touchUpInside)
        return button
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let complimentOptionVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        return stackView
    }()
    
    private lazy var useGrapesButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.titleSemibold.font
        container.foregroundColor = StumeetColor.gray50.color
        configuration.image = UIImage(resource: .StudyMember.grapesActivity32)
        configuration.imagePadding = 8
        configuration.attributedTitle = AttributedString("포도알 1개 사용하기", attributes: container)
        configuration.baseBackgroundColor = StumeetColor.primary700.color
        
        let button = UIButton(configuration: configuration, primaryAction: nil)

        return button
    }()
    
    // MARK: - Properties
    private var complimentOptionRowItems: [StudyMemberComplimentRowItem] = [
        StudyMemberComplimentRowItem(id: 0, title: "열정이 돋보이는 활동이에요", isSelected: false),
        StudyMemberComplimentRowItem(id: 1, title: "성실하게 참여했어요", isSelected: false),
        StudyMemberComplimentRowItem(id: 2, title: "결과물이 훌륭해요", isSelected: false)
    ]
    private var complimentOptionButtons: [StudyMemberComplimentButton] = []
    
    // MARK: - Init
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0)
    }
    
    override func setupAddView() {
        view.addSubview(popupContainer)
        popupContainer.addSubview(rootVStackView)
        popupContainer.addSubview(useGrapesButton)
        
        [
            closeContainerView,
            titleContainerView,
            complimentOptionVStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        setupComplimentOptionButtons()
        
        closeContainerView.addSubview(closeButton)
        titleContainerView.addSubview(titleLabel)
    }
    
    override func setupConstaints() {
        popupContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        rootVStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }

        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.verticalEdges.equalToSuperview()
            $0.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(3)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        useGrapesButton.snp.makeConstraints {
            $0.height.equalTo(81)
            $0.top.equalTo(rootVStackView.snp.bottom).offset(29)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(-5)
        }
    }
    
    override func bind() {
        // MARK: - Input
        
        // MARK: - Output
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopupView))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        popupContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        // TODO: API 연동 시 수정
        titleLabel.text = "홍길동님을 칭찬해주세요!"
        titleLabel.setColorAndFont(to: "홍길동", withColor: StumeetColor.gray900.color, withFont: StumeetFont.titleBold.font)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToExpandedState()
    }
    
    // MARK: - Function
    private func setupComplimentOptionButtons() {
        complimentOptionButtons = complimentOptionRowItems.map {
            let button = StudyMemberComplimentButton(title: $0.title)
            button.isSelectedState = $0.isSelected
            button.tag = $0.id
            button.addTarget(self, action: #selector(didTapComplimentAction), for: .touchUpInside)
            return button
        }
        complimentOptionButtons.forEach { complimentOptionVStackView.addArrangedSubview($0) }
    }
    
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

    @objc private func dismissPopupView() {
        animateToCollapsedState()
    }
    
    @objc private func didTapComplimentAction(_ sender: UIButton) {
        for button in complimentOptionButtons {
            button.isSelectedState = button.tag == sender.tag
        }
    }
}

extension StudyMemberComplimentPopupViewController:
    UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.popupContainer) == false else { return false }
        return true
    }
}
