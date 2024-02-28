//
//  CoordinatorTest.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/27.
//

import UIKit

// MARK: 참고 - Coordinator가 있기에 우선 임시로 test 붙임
protocol CoordinatorTest: AnyObject {
    var parentCoordinator: CoordinatorTest? { get set }
    var children: [CoordinatorTest] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

extension CoordinatorTest {
    func childDidFinish(child: Coordinator) {
        children.removeAll { $0 === child }
    }
}
