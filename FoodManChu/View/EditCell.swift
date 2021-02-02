//
//  EditCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit

class EditCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    func configCell(_ ingredient: Ingredients) {
        if ingredient.name != nil && ingredient.amount != nil {
            nameLabel.text = ingredient.name!
            amountTextField.text = ingredient.amount!
        }
    }
    

}
