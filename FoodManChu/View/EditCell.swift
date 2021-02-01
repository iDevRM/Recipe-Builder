//
//  EditCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit

class EditCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configCell(_ ingredient: Ingredients) {
        if ingredient.name != nil && ingredient.amount != nil {
            nameLabel.text = ingredient.name!
            amountLabel.text = ingredient.amount!
        }
    }
    

}
