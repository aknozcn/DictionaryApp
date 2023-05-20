//
//  UIApplication+Window.swift
//  DictionaryApp
//
//  Created by akin on 19.05.2023.
//

import UIKit

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}
