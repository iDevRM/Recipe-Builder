//
//  IngredientListCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/27/21.
//

import UIKit

class IngredientListCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configCell(_ name: String, _ amount: String) {
        amountLabel.text = amount
        nameLabel.text   = name
    }
}
