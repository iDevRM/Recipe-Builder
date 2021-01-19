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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var recipeArray = [Recipe]()
    var ingredients = Ingredients()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
                
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("new phone who dis")
        case 1:
            print("new phone who dis")
        case 2:
            print("new phone who dis")
        case 3:
            print("new phone who dis")
        case 4:
            print("new phone who dis")
        default:
            break
        }
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

//MARK: - Core Data Manipulation Methods
extension SearchVC {
    
    func addNewRecipe() {
        let newItem = Recipe(context: Constants.context)
        newItem.name = "Chicken Parmasean"
        newItem.descript = "Crispy and tender chicken with hot marinara sauce and fresh parmasean."
        newItem.instructions = "Its amazing just try it"
        newItem.prepTime = 35
      
        
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
    
    func removeRecipe(at index: Int) {
        Constants.context.delete(recipeArray[index])
        recipeArray.remove(at: index)
        saveItems()
    }
    
}

//MARK: - Core Data Search Delegates

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()

        let predicate = NSPredicate(format: "descript CONTAINS[cd] %@", searchBar.text!)

        request.predicate = predicate

        do {
            recipeArray = try Constants.context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }

        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRecipes()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
