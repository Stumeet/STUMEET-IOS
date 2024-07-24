//
//  Collection++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/07/10.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
