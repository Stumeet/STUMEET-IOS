//
//  Coordinator.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController { get set }
    var children: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator) {
        children.removeAll { $0 === child }
    }
}
