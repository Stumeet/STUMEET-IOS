//
//  ViewModelType.swift
//  Stumeet
//
//  Created by 정지훈 on 2/13/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
