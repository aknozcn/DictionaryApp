//
//  CustomSearchBar.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

class CustomSearchBar: UITextField {

    // MARK: - IBInspectables
    @IBInspectable var leading: CGFloat = 0

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftImage()
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    // MARK: - Overrides
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leadingText = super.leftViewRect(forBounds: bounds)
        leadingText.origin.x += leading
        return leadingText
    }

    // MARK: - Private Methods
    private func updateLeftImage() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = Colors.searchImageTintColor
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
}
