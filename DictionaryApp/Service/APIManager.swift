//
//  APIManager.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import Moya

// MARK: - APIManaging
protocol APIManaging {
    func fetchWord(baseURL: String, word: String, completion: @escaping (Result<[WordResponse], Error>) -> ())
    func fetchSynonymsWord(baseURL: String, word: String, completion: @escaping (Result<[SynonymsResponse], Error>) -> ())
}

class APIManager: APIManaging {
    
    // MARK: - Variables
    private var provider = MoyaProvider<APIRequest>(plugins: [NetworkLoggerPlugin()])
    
    // MARK: - Public Methods
    func fetchWord(baseURL: String, word: String, completion: @escaping (Result<[WordResponse], Error>) -> ()) {
        request(target: .getWord(baseURL: baseURL, word: word), completion: completion)
    }
    
    func fetchSynonymsWord(baseURL: String, word: String, completion: @escaping (Result<[SynonymsResponse], Error>) -> ()) {
        request(target: .getSynWord(baseURL: baseURL, word: word), completion: completion)
    }
}

// MARK: - Private Methods
private extension APIManager {
    func request<T: Decodable>(target: APIRequest, completion: @escaping(Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
