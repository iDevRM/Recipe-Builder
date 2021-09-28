//
//  SearchVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/8/21.
//

import UIKit
import CoreData

class SearchVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var searchBar:      UISearchBar!
    @IBOutlet weak var tableView:      UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var addButton:      UIBarButtonItem!
    
    var recipeArray     = [Recipe]()
    var ingredientArray = [Ingredients]()
    var searchFilter    = SearchFilters.searchByName.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.delegate             = self
        tableView.dataSource           = self
        searchBar.delegate             = self
        loadRecipes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? DetailVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.selectedRecipe = recipeArray[indexPath.row]
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            searchFilter = SearchFilters.searchByName.rawValue
        case 1:
            searchFilter = SearchFilters.searchByDescription.rawValue
        case 2:
            searchFilter = SearchFilters.searchByIngredients.rawValue
        case 4:
            searchFilter = SearchFilters.searchByCategory.rawValue
        default:
            break
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueConstants.addSegue, sender: self)
    }
}

//MARK: - TableView Delegate and DataSource
extension SearchVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellReuseId, for: indexPath) as? SearchTableViewCell {
            cell.configureCell(recipeArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueConstants.detailSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            Constants.context.delete(recipeArray[indexPath.row])
            Constants.save()
            recipeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

//MARK: - Core Data Manipulation Methods
extension SearchVC {
    
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipeArray = try Constants.context.fetch(request)
        } catch {
            debugPrint("Error fetching data from context: \(error)")
        }
    }
    
    
    func removeRecipe(at index: Int) {
        Constants.context.delete(recipeArray[index])
        recipeArray.remove(at: index)
        Constants.save()
    }
    
}

//MARK: - Core Data Search Delegates

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        if segmentControl.selectedSegmentIndex == 3 {
            let predicate = NSPredicate(format: "\(SearchFilters.searchByTime.rawValue) < %@", searchBar.text!)
            request.predicate = predicate
        } else {
            let predicate = NSPredicate(format: "\(searchFilter) CONTAINS[cd] %@", searchBar.text!)
            request.predicate = predicate
        }
        
        do {
            recipeArray = try Constants.context.fetch(request)
        } catch {
            debugPrint("Error fetching data from context: \(error)")
        }
       
        tableView.reloadData()
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadRecipes()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - Navigation controller methods
extension SearchVC: UINavigationControllerDelegate {
    override func didMove(toParent parent: UIViewController?) {
        loadRecipes()
        tableView.reloadData()
    }
}
