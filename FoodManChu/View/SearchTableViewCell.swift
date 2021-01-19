//
//  SearchTableViewCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/8/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail:   UIImageView!
    @IBOutlet weak var topLabel:    UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var view:        UIView!

    func configureCell(_ recipe: Recipe ) {
        thumbnail.image  = recipe.image as? UIImage ?? UIImage(named: "Instant-Pot-Spaghetti-Recipe-11-of-4-1024x681")
        thumbnail.layer.cornerRadius = 15
        view.layer.cornerRadius = 15
        topLabel.text    = recipe.name
        middleLabel.text = "\(String(format: "%0.f", recipe.prepTime)) min"
        bottomLabel.text = recipe.descript
    }

}
