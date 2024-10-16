//
//  StumeetConfirmationPopupViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/21.
//

import UIKit
import SnapKit

protocol StumeetConfirmationPopupViewControllerDelegate: AnyObject {
    func confirmAction()
    func cancelAction()
}

class StumeetConfirmationPopupViewController: BaseViewController {

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
    
    private let contextContainerView: UIView?

    private let actionContainerHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("네", for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("아니요", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    weak var delegate: StumeetConfirmationPopupViewControllerDelegate?
    
    // MARK: - Init
    init(contextView: UIView) {
        self.contextContainerView = contextView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0)
    }
    
    override func setupAddView() {
        view.addSubview(popupContainer)
        popupContainer.addSubview(rootVStackView)
        
        
        if let contextContainerView {
            rootVStackView.addArrangedSubview(contextContainerView)
        }
        
        rootVStackView.addArrangedSubview(actionContainerHStackView)
        

        [
            cancelButton,
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
    
    private func animateToCollapsedState(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = .black.withAlphaComponent(0.0)
            self.popupContainer.alpha = 0
        }, completion: { _ in
            completion?()
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    @objc private func confirmButtonTapped(_ sender: UIButton) {
        animateToCollapsedState { [weak self] in
            self?.delegate?.confirmAction()
        }
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        animateToCollapsedState { [weak self] in
            self?.delegate?.cancelAction()
        }
    }
}
