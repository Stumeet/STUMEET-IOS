//
//  ChangeProfileUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/9/24.
//

import Combine
import Foundation
import UIKit

protocol ChangeProfileUseCase {
    func downSampleImageData(url: URL) -> AnyPublisher<UIImage?, Never>
    func imageToData(image: UIImage) -> AnyPublisher<Data?, Never>
}

final class DefaultChangeProfileUseCase: ChangeProfileUseCase {
    
    func downSampleImageData(url: URL) -> AnyPublisher<UIImage?, Never> {
        let targetSize = CGSize(width: 180, height: 180)
        let cgManager = CoreGraphicManager()
        let downsampledImageData = cgManager.downsample(imageAt: url, to: targetSize, scale: UIScreen.main.scale)
        
        return Just(downsampledImageData).eraseToAnyPublisher()
    }
    
    func imageToData(image: UIImage) -> AnyPublisher<Data?, Never> {
        return Just(image.jpegData(compressionQuality: 0.1)).eraseToAnyPublisher()
    }
}
