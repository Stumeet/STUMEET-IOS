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
    
    func presentOnTop(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let presentedVC = navigationController.presentedViewController {
            // presentedViewController가 있으면 해당 컨트롤러에서 present
            presentedVC.present(viewController, animated: animated, completion: completion)
        } else if let topVC = navigationController.topViewController {
            // navigationController의 최상단 컨트롤러에서 present
            topVC.present(viewController, animated: animated, completion: completion)
        } else {
            // presentedViewController와 topViewController 둘 다 없을 경우 navigationController에서 present
            navigationController.present(viewController, animated: animated, completion: completion)
        }
    }
}
