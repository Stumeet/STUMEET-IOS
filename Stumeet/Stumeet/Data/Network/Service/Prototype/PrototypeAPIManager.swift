//
//  PrototypeAPIManager.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/28.
//

import Moya
import Foundation

final class PrototypeAPIManager {
    static let shared = PrototypeAPIManager()
    private let provider = MoyaProvider<PrototypeAPIService>()

    func login(_ completion: @escaping (PrototypeAPIData<PrototypeOauth>?) -> Void) {
        request(.login) { result in
            completion(result)
        }
    }

    private func request<T: Codable>( _ target: PrototypeAPIService, completion: @escaping (PrototypeAPIData<T>?) -> Void) {
        self.provider.request(target) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200...299:
                    do {
                        let decodedData = try JSONDecoder().decode(PrototypeAPIData<T>.self, from: response.data)
                        print(decodedData)
                        completion(decodedData)
                    } catch {
                        print(error)
                        print(String(data: response.data, encoding: .utf8) as Any)
                        completion(nil)
                    }
                default:
                    print("\(response.statusCode)")
                    print(String(data: response.data, encoding: .utf8) as Any)
                    completion(nil)
                }
            case let .failure(error):
                print("error \(error)")
                completion(nil)
            }
        }
    }
    
    private init() { }
}
