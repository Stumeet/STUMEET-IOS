//
//  MyPageCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

protocol MyPageNavigation: AnyObject {
    func goToMyPage()
}

final class MyPageCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToMyPage()
    }
}

extension MyPageCoordinator: MyPageNavigation {
    func goToMyPage() {
        let myPageVC = MyPageViewController(coordinator: self)
        navigationController.pushViewController(myPageVC, animated: true)
    }
}
