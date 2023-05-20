//
//  UITextField+PlaceHolder.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

extension UITextField {
    func setPlaceHolder(fontName: String, size: CGFloat) {
        let placeholderText = placeholder ?? ""
        var attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: Colors.placeHolderColor]
        if let font = UIFont(name: fontName, size: size) {
            attributes[.font] = font
        }
        attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}
