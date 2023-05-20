//
//  Loading.swift
//  DictionaryApp
//
//  Created by akin on 19.05.2023.
//

import UIKit

class Loading {
    
    // MARK: Instance
    public static let shared = Loading()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Variables
    private var containerView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Public Methods
    func show() {
        let window = UIApplication.shared.keyWindowInConnectedScenes
        if let window = window {
            containerView.frame = window.bounds
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
            activityIndicator.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
            containerView.addSubview(activityIndicator)
            
            window.addSubview(containerView)
        }
        
        activityIndicator.startAnimating()
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
        }
    }
}
