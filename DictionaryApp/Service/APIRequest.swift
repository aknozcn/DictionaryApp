//
//  APIRequest.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import Moya

// MARK: - Enums
enum APIRequest {
    case getWord(baseURL: String, word: String)
    case getSynWord(baseURL: String, word: String)
}

extension APIRequest: TargetType {
    
    // MARK: - Properties
    var baseURL: URL {
        switch self {
        case .getWord(let url, _), .getSynWord(let url, _):
            guard let url = URL(string: url) else {
                fatalError("Invalid URL: \(url)")
            }
            return url
        }
    }

    var path: String {
        switch self {
        case .getWord(_, let word):
            return "/\(word)"
        case .getSynWord(_, _):
            return "/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWord, .getSynWord:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .getWord:
            return .requestPlain
        case .getSynWord(_, let word):
            let parameters: [String: Any] = ["rel_syn": word]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }
}
