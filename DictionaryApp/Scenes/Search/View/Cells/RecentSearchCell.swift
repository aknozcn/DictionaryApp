//
//  RecentSearchCell.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

class RecentSearchCell: UITableViewCell {

    // MARK: - Variables
    static let identifier = "RecentSearchCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var wordLabel: UILabel!
    
    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    func configure(word: String) {
        wordLabel.text = word
    }
    
}
