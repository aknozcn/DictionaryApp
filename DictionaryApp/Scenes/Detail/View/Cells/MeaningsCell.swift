//
//  MeaningsCell.swift
//  DictionaryApp
//
//  Created by akin on 18.05.2023.
//

import UIKit

// MARK: - WordMeaning
struct WordMeaning {
    let order: String
    let partOfSpeech: String
    let definition: String
    let example: String
}

class MeaningsCell: UITableViewCell {

    // MARK: - Variables
    static let identifier = "MeaningsCell"

    // MARK: - IBOutlets
    @IBOutlet weak var meaningTitle: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var exampleTitleLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var exampleStackView: UIStackView!

    // MARK: - Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public Methods
    func configure(meaning: WordMeaning) {
        orderLabel.text = meaning.order
        meaningTitle.text = meaning.partOfSpeech.capitalized
        definitionLabel.text = meaning.definition
        exampleLabel.text = meaning.example
        exampleStackView.isHidden = meaning.example.isEmpty 
    }
}
