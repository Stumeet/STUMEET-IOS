//
//  CenterAlginCollectionViewLayout.swift
//  Stumeet
//
//  Created by 정지훈 on 2/12/24.
//

import UIKit

class CenterAlignCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
        // LayoutAttributes 복사
        let attributes = originalAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
        
        // 행별로 그룹화
        let rows = Dictionary(grouping: attributes, by: { $0.frame.minY })
        
        // 각 행을 순회하면서 가운데 정렬 조정
        rows.values.forEach { rowAttributes in
            // 행의 전체 너비 계산
            let rowWidth = rowAttributes.reduce(0) { $0 + $1.frame.width } + minimumInteritemSpacing * CGFloat(rowAttributes.count - 1)
            let inset = (collectionViewContentSize.width - rowWidth) / 2
            
            // 첫 번째 셀의 시작점 조정
            var offsetX = inset
            for attribute in rowAttributes {
                attribute.frame.origin.x = offsetX
                offsetX += attribute.frame.width + minimumInteritemSpacing
            }
        }
        
        return attributes
    }
}

