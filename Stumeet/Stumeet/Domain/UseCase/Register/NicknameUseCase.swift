//
//  NicknameUseCase.swift
//  Stumeet
//
//  Created by 정지훈 on 3/1/24.
//

import Combine
import Foundation

protocol NicknameUseCase {
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, Never>
    func checkNicknameLonggestThanTen(nickname: String) -> AnyPublisher<Bool, Never>
    func setNicknameCount(nickname: String) -> AnyPublisher<Int, Never>
    func setNextButtonEnable(isDuplicate: Bool, count: Int) -> AnyPublisher<Bool, Never>
    func checkIsValidNickname(nickname: String) -> AnyPublisher<Bool, Never>
}

final class DefaultNicknameUseCase: NicknameUseCase {
    
    private let repository: NicknameRepository
    
    init(repository: NicknameRepository) {
        self.repository = repository
    }
    
    func checkNicknameDuplicate(nickname: String) -> AnyPublisher<Bool, Never> {
       return repository.checkDuplicateNickname(nickname: nickname)
            .map { responseDTO -> Bool in
                return responseDTO.message == "닉네임이 중복되었습니다."
            }
            .catch { _ in Just(false).eraseToAnyPublisher() }
            .eraseToAnyPublisher()
    }
    
    func checkNicknameLonggestThanTen(nickname: String) -> AnyPublisher<Bool, Never> {
        return Just(nickname.count > 10).eraseToAnyPublisher()
    }
    
    func setNextButtonEnable(isDuplicate: Bool, count: Int) -> AnyPublisher<Bool, Never> {
        let isEnable = isDuplicate ? Just(false) : Just(count != 0)
        
        return isEnable.eraseToAnyPublisher()
    }
    
    func setNicknameCount(nickname: String) -> AnyPublisher<Int, Never> {
        return Just(nickname.count).eraseToAnyPublisher()
    }
    
    func checkIsValidNickname(nickname: String) -> AnyPublisher<Bool, Never> {
        let pattern = "^[a-zA-Z가-힣]+$"
        let result = NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: nickname)
        return Just(result).eraseToAnyPublisher()
    }
}
