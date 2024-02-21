//
//  TabBarCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    
    // TODO: - Coordinator 디테일하게 구현
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = TabBarViewController()
        tabBarController.setViewControllers(
            [
                makeHomeViewController(),
                makeStudyListViewController(),
                makeCalendarViewController(),
                makeMyPageViewController()
            ],
            animated: true)
        childCoordinators.append(self)
        tabBarController.modalPresentationStyle = .fullScreen
        navigationController.present(tabBarController, animated: true)
    }
    
    private func makeHomeViewController() -> UINavigationController {
        let homeVC = HomeViewController()
        let navigationContoreller =  UINavigationController(rootViewController: homeVC)
        navigationContoreller.tabBarItem.image = UIImage(systemName: "house")
        return navigationContoreller
    }
    
    private func makeStudyListViewController() -> UINavigationController {
        let studyListVC = StudyListViewController()
        let navigationContoreller =  UINavigationController(rootViewController: studyListVC)
        navigationContoreller.tabBarItem.image = UIImage(systemName: "book.pages")
        return navigationContoreller
    }
    
    private func makeCalendarViewController() -> UINavigationController {
        let calendarVC = CalendarViewController()
        let navigationContoreller =  UINavigationController(rootViewController: calendarVC)
        navigationContoreller.tabBarItem.image = UIImage(systemName: "calendar")
        return navigationContoreller
    }
    
    private func makeMyPageViewController() -> UINavigationController {
        let myPageeVC = MyPageViewController()
        let navigationContoreller =  UINavigationController(rootViewController: myPageeVC)
        navigationContoreller.tabBarItem.image = UIImage(systemName: "person")
        return navigationContoreller
    }
    
}
