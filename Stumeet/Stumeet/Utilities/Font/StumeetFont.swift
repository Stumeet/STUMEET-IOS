//
//  StumeetFont.swift
//  Stumeet
//
//  Created by 정지훈 on 2/13/24.
//

import UIKit

//import PretendardKit

enum StumeetFont {
    
    // MARK: - Heading
    case headingBold
    case headingSemibold
    case headingMedium
    case headingRegular
    
    // MARK: - Title
    case titleBold
    case titleSemibold
    case titleMedium
    
    // MARK: - SubTitle
    case subTitleSemiBold
    case subTitleMedium1
    case subTitleMedium2
    case subTitleRegular
    
    // MARK: - Body
    case bodyMedium16
    case bodyMedium15
    case bodyMedium14
    case bodysemibold
    
    // MARK: - Caption
    case captionMedium13
    case captionMedium12
    
}

extension StumeetFont {
    
    var font: UIFont {
        switch self {
            
        // Heading
        case .headingBold:
            return .pretendard(ofSize: 24, weight: .bold)
        case .headingSemibold:
            return .pretendard(ofSize: 24, weight: .semibold)
        case .headingMedium:
            return .pretendard(ofSize: 24, weight: .medium)
        case .headingRegular:
            return .pretendard(ofSize: 24, weight: .regular)
            
        // Title
        case .titleBold:
            return .pretendard(ofSize: 20, weight: .bold)
        case .titleSemibold:
            return .pretendard(ofSize: 20, weight: .semibold)
        case .titleMedium:
            return .pretendard(ofSize: 20, weight: .medium)
            
        // SubTitle
        case .subTitleSemiBold:
            return .pretendard(ofSize: 18, weight: .semibold)
        case .subTitleMedium1:
            return .pretendard(ofSize: 18, weight: .medium)
        case .subTitleMedium2:
            return .pretendard(ofSize: 17, weight: .medium)
        case .subTitleRegular:
            return .pretendard(ofSize: 17, weight: .regular)
            
        // Body
        case .bodyMedium16:
            return .pretendard(ofSize: 16, weight: .medium)
        case .bodyMedium15:
            return .pretendard(ofSize: 15, weight: .medium)
        case .bodyMedium14:
            return .pretendard(ofSize: 14, weight: .medium)
        case .bodysemibold:
            return .pretendard(ofSize: 16, weight: .semibold)
            
        // Caption
        case .captionMedium13:
            return .pretendard(ofSize: 13, weight: .medium)
        case .captionMedium12:
            return .pretendard(ofSize: 12, weight: .medium)
        }
    }
}
