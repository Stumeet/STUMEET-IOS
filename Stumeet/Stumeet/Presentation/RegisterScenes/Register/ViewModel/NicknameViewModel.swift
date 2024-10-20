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
        let isValidNickname: AnyPublisher<Bool, Never>
        let navigateToSelectRegionVC: AnyPublisher<Register, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: NicknameUseCase
    private var register: Register
    private let nicknameSubject = CurrentValueSubject<String, Never>("")
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(useCase: NicknameUseCase, register: Register) {
        self.useCase = useCase
        self.register = register
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // Input
        input.changeText
            .sink(receiveValue: nicknameSubject.send)
            .store(in: &cancellables)
        
        let isDuplicate = input.changeText
            .flatMap(useCase.checkNicknameDuplicate)
            .eraseToAnyPublisher()
        
        let isValidNickname = nicknameSubject
            .flatMap(useCase.checkIsValidNickname)
            .eraseToAnyPublisher()
        
        let count = input.changeText
            .flatMap(useCase.setNicknameCount)
            .eraseToAnyPublisher()
        
        let isBiggerThanTen = input.changeText
            .flatMap(useCase.checkNicknameLonggestThanTen)
            .eraseToAnyPublisher()
        
        let navigateToSelectRegionVC = input.didTapNextButton
            .flatMap { [weak self] _ in
                let nickname = self?.nicknameSubject.value
                self?.register.nickname = nickname
                return Just(self?.register)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
            
        let isNextButtonEnable = Publishers.CombineLatest(isDuplicate, count)
            .flatMap(useCase.setNextButtonEnable)
            .eraseToAnyPublisher()
        
        // Ouptut
        return Output(
            isDuplicate: isDuplicate,
            count: count,
            isBiggerThanTen: isBiggerThanTen,
            isNextButtonEnable: isNextButtonEnable,
            isValidNickname: isValidNickname,
            navigateToSelectRegionVC: navigateToSelectRegionVC
        )
    }
}
