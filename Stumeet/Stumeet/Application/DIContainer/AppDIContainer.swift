//
//  AppDIContainer.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import Foundation

final class AppDIContainer {
    // TODO: - 키값에 따라 활성유무
//    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - DIContainers of scenes
    func makeOnboardingScenesDIContainer() -> OnboardingScenesDIContainer {
        return OnboardingScenesDIContainer()
    }
}
