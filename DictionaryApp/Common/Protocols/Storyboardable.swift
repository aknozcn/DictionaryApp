//
//  Storyboardable.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

// MARK: - Enums
enum StoryboardName: String {
    case search = "Search"
    case detailScreen = "Detail"
}

//MARK: - Protocols
protocol Storyboardable {
    static var storyboardIdentifier: String { get }
    static func instantiate(storyboardName: StoryboardName) -> Self
}

// MARK: - Extensions
extension Storyboardable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static func instantiate(storyboardName: StoryboardName) -> Self {
        guard let viewController = UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("storyboard identifier : \(storyboardIdentifier)")
        }
        return viewController
    }
}
