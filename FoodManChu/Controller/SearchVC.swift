//
//  SearchVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/8/21.
//

import UIKit
import CoreData

class SearchVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recipeArray = [Recipe]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipes()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        print(recipeArray.count)
    }

}

//MARK: - TableView Delegate and DataSource

extension SearchVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseId, for: indexPath) as? SearchTableViewCell {
            cell.configureCell(recipeArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}

//MARK: - Core Data C.R.U.D functions
extension SearchVC {
    
    func addNewRecipe() {
        let newItem = Recipe(context: Constants.context)
        newItem.name = "Mealoaf"
        newItem.descript = "Delicious meatloaf, said no one ever."
        newItem.instructions = "Just cook it idiot."
        newItem.prepTime = 30
        
        saveItems()
    }
    
    func saveItems() {
        
        do {
            try Constants.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeArray = try Constants.context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
}
