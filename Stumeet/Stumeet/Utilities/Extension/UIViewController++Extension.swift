//
//  UIViewController++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit
import SnapKit

extension UIViewController {
    
    /// BackButton, Title navgationBar 생성
    func configureBackButtonTitleNavigationBarItems(title: String) {
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backButton),
            style: .plain,
            target: self,
            action: #selector(popViewController)
        )
        backButton.tintColor = .black
        
        let titleLabel = UILabel().setLabelProperty(
            text: title,
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 24
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backButton, spacer, navigationTitleItem]
    }
    
    func configureXButtonTitleNavigationBarItems(button: UIBarButtonItem, title: String) {
        
        let titleLabel = UILabel().setLabelProperty(
            text: title,
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 24
        self.navigationItem.leftBarButtonItems = [button, spacer, navigationTitleItem]
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Alert 보여주기
    /// - Parameters:
    ///   - title: Alert 제목: String
    ///   - message: Alert 내용: String
    ///   - buttonTitle1: Alert 버튼1 title: String
    ///   - buttonTitle2: Alert 버튼2 title: String? = nil
    ///   - action1: 버튼 1 액션: (() -> Void)? = nil
    ///   - action2: 버튼 2 액션: (() -> Void)? = nil
    func showAlert(title: String,
                   message: String,
                   buttonTitle1: String,
                   buttonTitle2: String?,
                   action1: (() -> Void)?,
                   action2: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button1 = UIAlertAction(title: buttonTitle1, style: .default, handler: { _ in
            action1?()
        })
        alert.addAction(button1)
        
        if let buttonTitle2 = buttonTitle2 {
            let button2 = UIAlertAction(title: buttonTitle2, style: .cancel, handler: { _ in
                action2?()
            })
            alert.addAction(button2)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Error  Alert 보여주기
    func showErrorAlert() {
        let rootView = UIView()
        let rootVStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 8
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = StumeetFont.titleBold.font
            label.textColor = StumeetColor.gray900.color
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = StumeetFont.titleMedium.font
            label.textColor = StumeetColor.gray800.color
            label.numberOfLines = 2
            label.textAlignment = .center
            return label
        }()
        
        rootView.addSubview(rootVStackView)
        
        [
            titleLabel,
            subtitleLabel
        ].forEach { rootVStackView.addArrangedSubview($0)}
        
        titleLabel.text = "오류!"
        subtitleLabel.text = "앱을 다시 시작해주세요."
        
        rootVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(48)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        let errorVC = StumeetConfirmationPopupViewController(contextView: rootView, type: .error)
        errorVC.modalPresentationStyle = .overFullScreen
        errorVC.modalTransitionStyle = .crossDissolve
        self.present(errorVC, animated: false, completion: nil)
    }
}
