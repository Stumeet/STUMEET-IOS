//
//  TabBarCoordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        initializeTabBar()
    }
    
    func initializeTabBar() {
        let tabbarController = UITabBarController()
        
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.parentCoordinator = parentCoordinator
        
        let homeItem = UITabBarItem()
        homeItem.title = "home"
        homeItem.image = UIImage(systemName: "house")
        homeNavigationController.tabBarItem = homeItem
        
        let studyListNavigationController = UINavigationController()
        
        // TODO: TabBar DI Container 만들기
        let dependencies = StudyListDIContainer.Dependencies(provider: AppDIContainer().networkServiceProvider)
        let studyListCoordinator = StudyListCoordinator(
            navigationController: studyListNavigationController,
            dependencies: StudyListDIContainer(dependencies: dependencies)
        )
        studyListCoordinator.parentCoordinator = parentCoordinator
        
        let studyListItem = UITabBarItem()
        studyListItem.title = "studyList"
        studyListItem.image = UIImage(systemName: "book.pages")
        studyListNavigationController.tabBarItem = studyListItem
        
        let calendarNavigationController = UINavigationController()
        let calendarCoordinator = CalendarCoordinator(navigationController: calendarNavigationController)
        calendarCoordinator.parentCoordinator = parentCoordinator
        
        let calendarItem = UITabBarItem()
        calendarItem.title = "calendar"
        calendarItem.image = UIImage(systemName: "calendar")
        calendarNavigationController.tabBarItem = calendarItem
        
        let myPageNavigationController = UINavigationController()
        let myPageCoordinator = MyPageCoordinator(navigationController: myPageNavigationController)
        myPageCoordinator.parentCoordinator = parentCoordinator
        
        let myPageItem = UITabBarItem()
        myPageItem.title = "myPage"
        myPageItem.image = UIImage(systemName: "person")
        myPageNavigationController.tabBarItem = myPageItem
        
        tabbarController.viewControllers = [
            homeNavigationController,
            studyListNavigationController,
            calendarNavigationController,
            myPageNavigationController
        ]
        
        tabbarController.modalPresentationStyle = .fullScreen
        
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        
        parentCoordinator?.children.append(homeCoordinator)
        parentCoordinator?.children.append(studyListCoordinator)
        parentCoordinator?.children.append(calendarCoordinator)
        parentCoordinator?.children.append(myPageCoordinator)
        
        homeCoordinator.start()
        studyListCoordinator.start()
        calendarCoordinator.start()
        myPageCoordinator.start()
    }
}
