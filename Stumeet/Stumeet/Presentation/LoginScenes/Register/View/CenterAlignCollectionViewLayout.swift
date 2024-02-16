//
//  CenterAlignCollectionViewLayout.swift
//  Stumeet
//
//  Created by 정지훈 on 2/12/24.
//

import UIKit

class CenterAlignCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // LayoutAttributes 복사
        let attributes = originalAttributes.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
        
        // 행별로 그룹화
        let rows = Dictionary(grouping: attributes, by: { $0.frame.minY })
        
        // 각 행을 순회하면서 가운데 정렬 조정
        rows.values.forEach { row in
            // 행의 전체 너비 계산 (마지막 아이템까지의 거리 포함)
            let rowWidth = row.reduce(0) { $0 + $1.frame.width } + minimumInteritemSpacing * CGFloat(row.count - 1)
            
            // 컬렉션 뷰의 사용 가능한 너비 계산 (sectionInset 고려)
            let availableWidth = (collectionView?.frame.width)! - sectionInset.left - sectionInset.right
            
            if rowWidth < availableWidth {
                // 행의 아이템들이 꽉 차지 않을 경우 왼쪽 정렬
                var offsetX = sectionInset.left // 시작점을 섹션의 왼쪽 인셋으로 설정
                for attribute in row {
                    attribute.frame.origin.x = offsetX
                    offsetX += attribute.frame.width + minimumInteritemSpacing
                }
            } else {
                // 행의 아이템들이 꽉 찰 경우 가운데 정렬
                let inset = (availableWidth - rowWidth) / 2
                var offsetX = max(inset, sectionInset.left)
                for attribute in row {
                    attribute.frame.origin.x = offsetX
                    offsetX += attribute.frame.width + minimumInteritemSpacing
                }
            }
        }
        
        return attributes
    }
}
