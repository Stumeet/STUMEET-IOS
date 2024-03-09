//
//  ChangeProfileViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 2/14/24.
//

import UIKit

import Combine

final class ChangeProfileViewModel: ViewModelType {
    
    // MARK: - Input
    struct Input {
        let didTapChangeProfileButton: AnyPublisher<Void, Never>
        let didTapNextButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
        let navigateToNicknameVC: AnyPublisher<Data, Never>
        let showAlbum: AnyPublisher<Void, Never>
        let profileImage: AnyPublisher<UIImage, Never>
    }
    
    // MARK: - Properties
    let didSelectPhoto = PassthroughSubject<URL, Never>()
    let useCase: ChangeProfileUseCase
    let selectedPhotoSubject = CurrentValueSubject<UIImage, Never>(UIImage(named: "changeProfileCharacter")!)
    
    // MARK: - Init
    init(useCase: ChangeProfileUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        
        // Input
        let showAlbum = input.didTapChangeProfileButton
        
        let profileImage = didSelectPhoto
            .flatMap(useCase.downSampleImageData)
            .compactMap { $0 }
            .handleEvents(receiveOutput: selectedPhotoSubject.send)
            .eraseToAnyPublisher()
        
        let navigateToNicknameVC = input.didTapNextButton
            .flatMap { [weak self] _ -> AnyPublisher<Data?, Never> in
                guard let self = self else { return Empty<Data?, Never>().eraseToAnyPublisher() }
                
                return self.useCase.imageToData(image: self.selectedPhotoSubject.value)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        
        // Output
        return Output(
            navigateToNicknameVC: navigateToNicknameVC,
            showAlbum: showAlbum,
            profileImage: profileImage
        )
    }
}
