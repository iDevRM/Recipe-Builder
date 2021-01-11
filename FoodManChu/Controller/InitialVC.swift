//
//  ViewController.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/7/21.
//

import UIKit
import CoreData

class InitialVC: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    
    var dataIsParsed = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !dataIsParsed  {
            getDummyData()
        }
    }
    
    @IBAction func button1WasTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "searchVCSegue", sender: nil)
        
    }
    
    @IBAction func button2WasTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func button3WasTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func button4WasTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func button5WasTapped(_ sender: UIButton) {
        
    }
    
    
}

extension InitialVC: NSFetchedResultsControllerDelegate {
    func getDummyData() {
        let add = Ingredients(context: Constants.context)
        add.everyIngredient = ["Chicken Breast","Ham","Turkey","Fish","Crab","Bacon","Milk","Cheese","Butter","Eggs","Orange","Strawberry","Kiwi","Blueberries","Mango","Banana","Lemon","Tomatoes","Spinach ","Potatoes","Onion","Mushroom","Lettuce ","Jalapeño ","Garlic","Cucumber","Carrot","Broccoli","Green beans","Bell Pepper","Avocado","Ginger ","Coriander ","Chives","Sage ","Oregano","Paprika","Lemongrass","Mint","Salt","Pepper","Nutmeg","Cinnamon","Garam Masala","Fennel","Dill","Curry","Cumin","Thyme","Cayenne","Star Anise","Basil","Parsley","Cloves","Cayenne","All spice","Sugar","Flour","Baking powder","Baking soda","Olive oil","Avocado oil","Coconut oil","Almonds","Peanuts","Cashews","Pecans","Mustard Seed","Pistachio"]
        
        let cat = Categories(context: Constants.context)
        cat.category = ["Meat","Vegetarian","Vegan","Paleo","Keto"]
        
        let recipe1 = Recipe(context: Constants.context)
        recipe1.image = UIImage(named: "Instant-Pot-Spaghetti-Recipe-11-of-4-1024x681")
        recipe1.descript = "Its yummy"
        recipe1.instructions = "Just Cook it"
        
        Constants.ad.saveContext()
        
        dataIsParsed = true
    }
}

