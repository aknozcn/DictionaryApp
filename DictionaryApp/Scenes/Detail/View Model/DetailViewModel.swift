//
//  DetailViewModel.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func wordFetched()
    func wordFetchFailed()
    func synonymsWordsFetched()
}

class DetailViewModel {

    // MARK: - Variables
    private let apiManager: APIManaging
    private var wordDetail: [WordResponse] = []
    private var filteredMeanings: [Meaning] = []
    private var synonymsWords: [SynonymsResponse] = []
    private var searchWord: String = ""
    private var isFiltered: Bool = false

    //MARK: - Delegate
    weak var delegate: DetailViewModelDelegate?

    // MARK: - Initialization
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }

    // MARK: - Properties
    var firstWord: WordResponse? {
        return wordDetail.first
    }

    var synonyms: [SynonymsResponse]? {
        return synonymsWords
    }
    
    var getHighScoreSynonyms: [SynonymsResponse] {
        let sorted = synonymsWords.sorted{$0.score > $1.score}.prefix(5)
        return Array(sorted)
    }

    var filterState: Bool {
        get {
            return isFiltered
        }
        set {
            isFiltered = newValue
        }
    }

    var meaningsCount: Int {
        if isFiltered {
            return filteredMeanings.count
        } else {
            return wordDetail.first?.meanings.count ?? 0
        }
    }

    // MARK: - Public Methods
    func setSearchWord(word: String) {
        searchWord = word
    }

    func setFilteredState(isFiltered: Bool) {
        self.isFiltered = isFiltered
    }

    func setFilteredMeanings(meanings: [Meaning]) {
        filteredMeanings = meanings
    }

    func getDefinitionCount(for section: Int) -> Int {
        if isFiltered {
            if section <= filteredMeanings[section].definitions.count {
                return filteredMeanings[section].definitions.count
            }

        } else {
            if section < meaningsCount {
                guard let meaning = wordDetail.first?.meanings[section], section <= meaning.definitions.count else {
                    return 0
                }
                return meaning.definitions.count
            }
           
        }
        return 0
    }

    func getWordMeaning(for indexPath: IndexPath) -> WordMeaning? {
        if isFiltered {
            if indexPath.section < filteredMeanings.count {
                let meaning = filteredMeanings[indexPath.section]
                return generateWordMeaning(indexPath: indexPath, meaning: meaning)
            }
        } else {
            guard let firstWord = wordDetail.first, indexPath.section < firstWord.meanings.count else {
                return nil
            }

            let meaning = firstWord.meanings[indexPath.section]
            return generateWordMeaning(indexPath: indexPath, meaning: meaning)
        }
        
        return nil
    }

    func fetchWordDetail() {
        apiManager.fetchWord(baseURL: Environment.wordAPI, word: searchWord) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.wordDetail = data
                self.delegate?.wordFetched()
            case .failure(let error):
                Loading.shared.hide()
                self.delegate?.wordFetchFailed()
                print("Error fetching word detail: \(error)")
            }
        }
    }

    func fetchSynonymsWords() {
        apiManager.fetchSynonymsWord(baseURL: Environment.synWordAPI, word: searchWord) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let data):
                self.synonymsWords = data
                self.delegate?.synonymsWordsFetched()
            case .failure(let error):
                Loading.shared.hide()
                print("Error fetching synonyms words: \(error)")
            }
        }
    }
}

// MARK: - Private Methods
private extension DetailViewModel {
    func generateWordMeaning(indexPath: IndexPath, meaning: Meaning?) -> WordMeaning? {
        guard let meaning = meaning else {
            return nil
        }

        let order = "\(indexPath.row + 1) - "

        if indexPath.section < meaning.definitions.count {
            let definition = meaning.definitions[indexPath.row]
            let example = definition.example ?? ""
            return WordMeaning(order: order, partOfSpeech: meaning.partOfSpeech, definition: definition.definition, example: example)
        }

        return nil
    }
}
