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
        let pushNickNameVC: AnyPublisher<Void, Never>
        let showAlbum: AnyPublisher<Void, Never>
        let profileImage: AnyPublisher<UIImage, Never>
    }
    
    // MARK: - Properties
    let didSelectPhoto = PassthroughSubject<URL, Never>()
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        // Input
        
        let pushNickNameVC = input.didTapNextButton
        
        
        let showAlbum = input.didTapChangeProfileButton
        
        
        let selectedPhoto = didSelectPhoto
            .map { url in
                let targetSize = CGSize(width: 180, height: 180)
                let cgManager = CoreGraphicManager()
                let downsampledImageData = cgManager.downsample(imageAt: url, to: targetSize, scale: UIScreen.main.scale)
                
                return downsampledImageData
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        // Output
        
        return Output(
            pushNickNameVC: pushNickNameVC,
            showAlbum: showAlbum,
            profileImage: selectedPhoto
        )
    }
}
