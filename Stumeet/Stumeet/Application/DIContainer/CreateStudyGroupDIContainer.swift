//
//  CreateStudyGroupDIContainer.swift
//  Stumeet
//
//  Created by 정지훈 on 7/24/24.
//

import Foundation

final class CreateStudyGroupDIContainer: CreateStudyGroupCoordinatorDependencies {
    
    typealias Navigation = MyStudyGroupListNavigation
    
    struct Dependencies {
        let provider: NetworkServiceProvider
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - CreateStudyGroupVC
    
    func makeCreateStudyGroupVC(coordinator: any CreateStudyGroupNavigation) -> CreateStudyGroupViewController {
        CreateStudyGroupViewController()
    }
    
    
}
