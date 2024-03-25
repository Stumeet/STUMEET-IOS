//
//  CalendarCoordinator.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/03/25.
//

import UIKit

final class CalendarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToCalendar()
    }
}

extension CalendarCoordinator: CalendarNavigation {
    func goToCalendar() {
        let calendarVC = CalendarViewController(coordinator: self)
        navigationController.pushViewController(calendarVC, animated: true)
    }
}

protocol CalendarNavigation: AnyObject {
    func goToCalendar()
}
