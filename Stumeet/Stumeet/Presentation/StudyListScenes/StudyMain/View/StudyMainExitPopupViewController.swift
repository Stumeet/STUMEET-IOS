//
//  StudyMainExitPopupViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/26.
//

import UIKit
import SnapKit

class StudyMainExitPopupViewController: BaseViewController {

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
    
    private let titleContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray600.color
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let actionContainerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("네", for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font

        return button
    }()
    
    private lazy var declineButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        button.addTarget(self, action: #selector(dismissPopupView), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0)
    }
    
    override func setupAddView() {
        view.addSubview(popupContainer)
        popupContainer.addSubview(rootVStackView)
        
        [
            titleContainerView,
            actionContainerHStackView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        titleContainerView.addSubview(titleLabel)

        [
            declineButton,
            confirmButton
        ].forEach { actionContainerHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        popupContainer.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        actionContainerHStackView.snp.makeConstraints {
            $0.height.equalTo(72)
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popupContainer.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        // TODO: API 연동 시 수정
        titleLabel.text = "자바를 자바 스터디를\n나가시겠어요?"
        titleLabel.setColorAndFont(to: "자바를 자바", withColor: StumeetColor.gray900.color, withFont: StumeetFont.titleBold.font)
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
