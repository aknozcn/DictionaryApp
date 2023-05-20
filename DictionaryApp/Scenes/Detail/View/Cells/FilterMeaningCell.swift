//
//  FilterMeaningCell.swift
//  DictionaryApp
//
//  Created by akin on 19.05.2023.
//

import UIKit

class FilterMeaningCell: UICollectionViewCell {

    // MARK: - Variables
    static let identifier = "FilterMeaningCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var meaningLabel: UILabel!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public Methods
    func configure(meaning: String) {
        self.layer.borderWidth = 1
        self.layer.borderColor = Colors.filterDeSelectBorderColor.cgColor
        self.layer.cornerRadius = 15
        meaningLabel.text = meaning
    }

}
