//
//  SearchVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/8/21.
//

import UIKit
import CoreData

class SearchVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var searchBar     : UISearchBar!
    @IBOutlet weak var tableView     : UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var recipeArray  = [Recipe]()
    
    var searchFilter = "name"

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate   = self
        tableView.dataSource = self
        searchBar.delegate   = self
    
        loadRecipes()
        
    }
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
    
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchFilter = SearchFilters.searchByName
        case 1:
            searchFilter = SearchFilters.searchByDescription
        case 2:
            searchFilter = SearchFilters.searchByIngredients
        case 3:
            searchFilter = SearchFilters.searchByTime
        case 4:
            searchFilter = SearchFilters.searchByCategory
        default:
            break
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addSegue, sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if let destVC = parent as? SearchVC {
            destVC.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? DetailVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.selectedRecipe = recipeArray[indexPath.row]
            }
        }
    }
}
    


//MARK: - Core Data Manipulation Methods
extension SearchVC {
    
    func saveItems() {
        do {
            try Constants.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
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
        
        let predicate = NSPredicate(format: "\(searchFilter) CONTAINS[cd] %@", searchBar.text!)

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
