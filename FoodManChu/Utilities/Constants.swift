//
//  Constants.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/11/21.
//

import Foundation
import UIKit

struct Constants {
    static let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let cellReuseId = "RecipeCell"
    static let detailSegue = "DetailSegue"
    static let addSegue    = "AddSegue"
    
    static let categories: [String?] = ["Meat","Vegetarian","Vegan","Paleo","Keto"]
    
    static var ingredients = ["Ground Beef", "Chicken Breast", "Ham","Turkey", "Fish", "Crab", "Bacon", "Milk","Cheese","Butter","Orange","Strawberry","Kiwi","Blueberry","Mango","Banana","Tomato","Spinach","Potato","Onion","Mushroom","Lettuce","Jalapeño","Garlic","Cucumber","Carrot","Broccoli","Green bean","Bell Pepper","Avocado","Ginger","Coriander","Chives","Sage","Oregano","Paprika","Lemongrass","Mint","Salt","Pepper","Nutmeg","Cinnamon","Garam Masala","Fennel","Dill","Curry","Cumin","Thyme","Cayenne","Star Anise","Basil","Parsley","Cloves","Cayenne","All spice","Sugar","Flour","Baking powder","Baking Soda","Olive oil","Avocado oil","Coconut oil","Almonds","Peanuts","Cashews","Pecans","Mustard Seed","Pistachio"]
}


