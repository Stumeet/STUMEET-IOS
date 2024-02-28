//
//  LoginDelegate.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/29.
//

import Foundation

protocol LoginProtocol {
    func signIn()
    func signOut(_ completion: @escaping (Bool) -> ())
    func delete(_ completion: @escaping (Bool) -> ())
}
