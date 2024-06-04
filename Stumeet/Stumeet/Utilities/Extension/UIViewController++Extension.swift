//
//  UIViewController++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit

extension UIViewController {
    
    /// BackButton, Title navgationBar 생성
    func configureBackButtonTitleNavigationBarItems(title: String) {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backButton"),
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
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backButton, navigationTitleItem]
    }
    
    func configureXButtonTitleNavigationBarItems(title: String) {
        let xButton = UIBarButtonItem(
            image: UIImage(named: "xMark"),
            style: .plain,
            target: self,
            action: nil
        )
        xButton.tintColor = .black
        
        let titleLabel = UILabel().setLabelProperty(
            text: title,
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [xButton, navigationTitleItem]
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
}
