//
//  OnboardingViewModel.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/23.
//
struct OnboardingViewModelActions {
    let showSnsLogin: () -> Void
}

protocol OnboardingViewModelInput {

}

protocol OnboardingViewModelOutput {

}

typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

final class DefaultOnboardingViewModel: OnboardingViewModel {
    
    private let actions: OnboardingViewModelActions?
    
    init(
        actions: OnboardingViewModelActions? = nil
    ) {
        self.actions = actions
    }
}
