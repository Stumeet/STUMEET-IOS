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
    
    
    // MARK: - Init
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // Input
        let isDuplicate = input.changeText
            .map { $0 == "Guest" }
            .eraseToAnyPublisher()
        
        let count = input.changeText
            .filter { $0.count <= 10}
            .map { $0.count }
            .eraseToAnyPublisher()
        
        let isBiggerThanTen = input.changeText
            .map { $0.count > 10 }
            .eraseToAnyPublisher()
        
        let navigateToSelectRegionVC = input.didTapNextButton
            
        
        let isEnable = Publishers.CombineLatest(isDuplicate, count)
            .map { isDuplicate, count in
                if !isDuplicate {
                    return count != 0
                } else {
                    return false
                }
            }
            .eraseToAnyPublisher()
        
        // Output
        return Output(
            isDuplicate: isDuplicate,
            count: count,
            isBiggerThanTen: isBiggerThanTen,
            isNextButtonEnable: isEnable,
            navigateToSelectRegionVC: navigateToSelectRegionVC
        )
    }
}
