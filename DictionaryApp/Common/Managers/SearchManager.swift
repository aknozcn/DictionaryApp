//
//  SearchManager.swift
//  DictionaryApp
//
//  Created by akin on 19.05.2023.
//

import Foundation

class SearchManager {
    
    // MARK: Instance
    static let shared = SearchManager()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Variables
    private var recentSearches: [String] = []
    private let recentShowCount = 5
    
    // MARK: - Public Methods
    func getRecentSearches() -> [String] {
        return recentSearches.reversed()
    }

    func addRecentSearches(word: String) {
        if recentSearches.count >= recentShowCount {
            recentSearches.removeFirst()
        }
        recentSearches.append(word)
    }
}
