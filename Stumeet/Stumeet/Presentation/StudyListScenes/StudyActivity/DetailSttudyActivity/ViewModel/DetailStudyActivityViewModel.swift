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
        let didTapMemeberButton: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    
    struct Output {
        let items: AnyPublisher<[DetailStudyActivitySectionItem], Never>
        let category: AnyPublisher<String, Never>
        let presentToPhotoListVC: AnyPublisher<([String], Int), Never>
        let presentToMemeberListVC: AnyPublisher<Void, Never>
    }
    
    // MARK: - Properties
    
    private let useCase: DetailStudyActivityUseCase
    private let studyID: Int
    private let activityID: Int
    
    // MARK: - Init
    
    init(useCase: DetailStudyActivityUseCase, studyID: Int, activityID: Int) {
        self.useCase = useCase
        self.studyID = studyID
        self.activityID = activityID
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        
        let items = useCase.getDetailActivityItem(studyID: studyID, activityID: activityID)
            .map {
                [
                    DetailStudyActivitySectionItem.topCell($0.top),
                    DetailStudyActivitySectionItem.photoCell($0.photo),
                    DetailStudyActivitySectionItem.bottomCell($0.bottom)
                ]
            }
            .eraseToAnyPublisher()
        
        let category = items
            .compactMap { items in
                if case .topCell(let topItem) = items[0]{
                    return topItem?.category.title
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        let presentToPhotoListVC = input.didSelectedCell
            .filter { $0.section == 1 }
            .combineLatest(items)
            .flatMap(useCase.setPresentedImage)
            .eraseToAnyPublisher()
        
        let presentToMemeberListVC = input.didTapMemeberButton
            .eraseToAnyPublisher()
        
        return Output(
            items: items,
            category: category,
            presentToPhotoListVC: presentToPhotoListVC,
            presentToMemeberListVC: presentToMemeberListVC
        )
    }
}
