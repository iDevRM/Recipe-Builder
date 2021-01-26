//
//  DetailVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var instructionslLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        if selectedRecipe != nil {
            setTextForAllLabels(with: selectedRecipe)
        }
        
    }
    
    func setTextForAllLabels(with recipe: Recipe?) {
        var items = ""
        image.image = recipe!.image as? UIImage ?? UIImage(named: "Instant-Pot-Spaghetti-Recipe-11-of-4-1024x681")
        nameLabel.text = recipe!.name
        prepTimeLabel.text = "\(String(format: "%0.f", recipe!.prepTime)) min"
        descriptionLabel.text = recipe!.descript
        instructionslLabel.text = recipe!.instructions!
        let ingredients = recipe!.ingredients as! Set<Ingredients>
        for i in ingredients.first!.name! {
            items += "\(i),"
        }
        ingredientsLabel.text = items
        let category = recipe!.category as! Set<Categories>
        categoryLabel.text = "Category : \(category.first!.name!)"
    }
}
