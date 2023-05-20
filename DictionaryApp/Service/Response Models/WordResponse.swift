//
//  WordResponse.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import Foundation

// MARK: - WordResponse
struct WordResponse: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let meanings: [Meaning]
    let license: License
    let sourceUrls: [String]
}

// MARK: - License
struct License: Codable {
    let name: String
    let url: String
}

// MARK: - Meaning
struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms, antonyms: [String]
}

// MARK: - Definition
struct Definition: Codable {
    let definition: String
    let synonyms, antonyms: [String]
    let example: String?
}

// MARK: - Phonetic
struct Phonetic: Codable {
    let audio: String
    let sourceURL: String?
    let license: License?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case audio
        case sourceURL = "sourceUrl"
        case license, text
    }
}
