//
//  OnboardingViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//

import Combine

final class OnboardingViewModel: ViewModelType {
    // MARK: - Input
    struct Input {
        let didTapNextButton: AnyPublisher<Void, Never>
    }

    // MARK: - Output
    struct Output {
        let navigateToSnsLoginVC: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let navigateToSnsLogin = input.didTapNextButton
        
        return Output(
            navigateToSnsLoginVC: navigateToSnsLogin
        )
    }
}
