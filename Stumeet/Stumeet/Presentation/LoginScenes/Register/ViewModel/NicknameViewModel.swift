//
//  NicknameViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import Combine
import Foundation

final class NicknameViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let changeText: AnyPublisher<String, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let isDuplicate: AnyPublisher<Bool, Never>
        let count: AnyPublisher<Int, Never>
        let isBiggerThanTen: AnyPublisher<Bool, Never>
        let isNextButtonEnable: AnyPublisher<Bool, Never>
        let navigateToSelectRegionVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    let useCase: NicknameUseCase
    let register: Register
    
    // MARK: - Init
    init(useCase: NicknameUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let isDuplicate = input.changeText
            .flatMap(useCase.checkNicknameDuplicate)
            .eraseToAnyPublisher()
        
        let count = input.changeText
            .flatMap(useCase.setNicknameCount)
            .eraseToAnyPublisher()
        
        let isBiggerThanTen = input.changeText
            .flatMap(useCase.checkNicknameLonggestThanTen)
            .eraseToAnyPublisher()
        
        let navigateToSelectRegionVC = input.didTapNextButton
            
        
        let isNextButtonEnable = Publishers.CombineLatest(isDuplicate, count)
            .flatMap(useCase.setNextButtonEnable)
            .eraseToAnyPublisher()
        
        return Output(
            isDuplicate: isDuplicate,
            count: count,
            isBiggerThanTen: isBiggerThanTen,
            isNextButtonEnable: isNextButtonEnable,
            navigateToSelectRegionVC: navigateToSelectRegionVC
        )
    }
}
