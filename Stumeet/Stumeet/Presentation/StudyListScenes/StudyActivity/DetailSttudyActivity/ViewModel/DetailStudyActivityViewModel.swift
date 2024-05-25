//
//  DetailStudyActivityViewModel.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import Foundation

final class DetailStudyActivityViewModel: ViewModelType {
    
    // MARK: - Input
    
    struct Input {
        let didSelectedCell: AnyPublisher<IndexPath, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailStudyActivitySectionItem], Never>
        let presentToPhotoListVC: AnyPublisher<([String], Int), Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailStudyActivityUseCase
    
    // MARK: - Init
    
    init(useCase: DetailStudyActivityUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.setDetailActivityItem()
        
        let presentToPhotoListVC = input.didSelectedCell
            .filter { $0.section == 1 }
            .combineLatest(items)
            .flatMap(useCase.setPresentedImage)
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            presentToPhotoListVC: presentToPhotoListVC
        )
    }
}
