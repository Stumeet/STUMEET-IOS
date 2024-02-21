//
//  UIViewController++Extension.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit

extension UIViewController {
    
    /// RegisterScene에 사용되는 navgationBar 생성
    func configureRegisterNavigationBarItems() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backButton"),
            style: .plain,
            target: self,
            action: #selector(popViewController)
        )
        backButton.tintColor = .black
        
        let titleLabel = UILabel().setLabelProperty(
            text: "프로필 설정",
            font: StumeetFont.titleMedium.font,
            color: nil
        )
        
        let navigationTitleItem = UIBarButtonItem(customView: titleLabel)
        
        self.navigationItem.leftBarButtonItems = [backButton, navigationTitleItem]
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
