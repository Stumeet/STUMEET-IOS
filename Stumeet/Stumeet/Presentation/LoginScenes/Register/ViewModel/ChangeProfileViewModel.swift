//
//  ChangeProfileViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import Foundation

import Combine

final class ChangeProfileViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didTapChangeProfileButton: AnyPublisher<Void, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let pushNickNameVC: AnyPublisher<Void, Never>
        let showAlbum: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // Input
        
        let pushNickNameVC = input.didTapNextButton
            .eraseToAnyPublisher()
        
        let showAlbum = input.didTapChangeProfileButton
            .eraseToAnyPublisher()
        
        // Output
        
        return Output(
            pushNickNameVC: pushNickNameVC,
            showAlbum: showAlbum
        )
    }
}
