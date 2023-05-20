//
//  SynonymsCell.swift
//  DictionaryApp
//
//  Created by akin on 20.05.2023.
//

import UIKit

class SynonymsCell: UICollectionViewCell {

    // MARK: - Variables
    static let identifier = "SynonymsCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var wordLabel: UILabel!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public Methods
    func configure(word: String) {
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.filterDeSelectBorderColor.cgColor
        self.layer.cornerRadius = 15
        wordLabel.text = word
    }
}
