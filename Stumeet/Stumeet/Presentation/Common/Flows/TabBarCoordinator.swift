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
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        initializeTabBar()
    }
    
    func initializeTabBar() {
        let tabbarController = UITabBarController()
        tabbarController.setupBarAppearance()
        
        let homeNavigationController = UINavigationController()
        let homeDIContainer = appDIContainer.makeHomeDIContainer()
        let homeCoordinator = homeDIContainer.makeHomeCoordinator(navigationController: homeNavigationController)
        homeNavigationController.setupBarAppearance()
        homeCoordinator.parentCoordinator = parentCoordinator
        
        let homeItem = UITabBarItem()
        homeItem.title = "home"
        homeItem.image = UIImage(systemName: "house")
        homeNavigationController.tabBarItem = homeItem
        
        let studyListNavigationController = UINavigationController()
        let studyListDIContainer = appDIContainer.makeMyStudyGroupListDIContainer()
        let studyListCoordinator = studyListDIContainer.makeMyStudyGroupListCoordinator(navigationController: studyListNavigationController)
        studyListNavigationController.setupBarAppearance()
        studyListCoordinator.parentCoordinator = parentCoordinator
        
        let studyListItem = UITabBarItem()
        studyListItem.title = "studyList"
        studyListItem.image = UIImage(systemName: "book.pages")
        studyListNavigationController.tabBarItem = studyListItem
        
        let calendarNavigationController = UINavigationController()
        let calendarDIContainer = appDIContainer.makeCalenderDIContainer()
        let calendarCoordinator = calendarDIContainer.makeCalenderCoordinator(navigationController: calendarNavigationController)
        calendarNavigationController.setupBarAppearance()
        calendarCoordinator.parentCoordinator = parentCoordinator
        
        let calendarItem = UITabBarItem()
        calendarItem.title = "calendar"
        calendarItem.image = UIImage(systemName: "calendar")
        calendarNavigationController.tabBarItem = calendarItem
        
        
        let myNavigationController = UINavigationController()
        let myDIContainer = appDIContainer.makeMyDIContainer()
        let myCoordinator = myDIContainer.makeMyCoordinator(navigationController: myNavigationController)
        myNavigationController.setupBarAppearance()
        myCoordinator.parentCoordinator = parentCoordinator
        
        let myItem = UITabBarItem()
        myItem.title = "my"
        myItem.image = UIImage(systemName: "person")
        myNavigationController.tabBarItem = myItem
        
        tabbarController.viewControllers = [
            homeNavigationController,
            studyListNavigationController,
            calendarNavigationController,
            myNavigationController
        ]
        
        tabbarController.modalPresentationStyle = .fullScreen
        
        navigationController.pushViewController(tabbarController, animated: true)
        navigationController.isNavigationBarHidden = true
        
        parentCoordinator?.children.append(homeCoordinator)
        parentCoordinator?.children.append(studyListCoordinator)
        parentCoordinator?.children.append(calendarCoordinator)
        parentCoordinator?.children.append(myCoordinator)
        
        homeCoordinator.start()
        studyListCoordinator.start()
        calendarCoordinator.start()
        myCoordinator.start()
    }
}
