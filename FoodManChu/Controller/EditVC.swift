//
//  EditVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit
import CoreData

class EditVC: UIViewController {
    @IBOutlet weak var nameTextField:         UITextField!
    @IBOutlet weak var timeTextField:         UITextField!
    @IBOutlet weak var descriptionTextField:  UITextField!
    @IBOutlet weak var instructionsTextField: UITextField!
    @IBOutlet weak var tableView:             UITableView!
    @IBOutlet weak var categoryTextField:     UITextField!
    @IBOutlet weak var doneEditingButton:     UIButton!
    @IBOutlet weak var image:                 UIImageView!
    
    var selectedRecipe:   Recipe!
    var ingredientList =  [Ingredients]()
    var editedIngredient: Ingredients?
    var set =             Set<Ingredients>()
    var categories =      [Categories]()
    let categoryPicker =  UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneEditingButton.layer.cornerRadius = 5
        image.layer.cornerRadius = 10
        setAllDelegates()
        setAllTextFields()
        setIngredientList()
        createPicker()
    }
    
    func setIngredientList() {
        if let set = selectedRecipe.ingredients as? Set<Ingredients> {
            for i in set {
                ingredientList.append(i)
            }
        }
    }
    
    func setAllTextFields() {
        nameTextField.text = selectedRecipe.name
        timeTextField.text = selectedRecipe.prepTime
        descriptionTextField.text = selectedRecipe.descript
        instructionsTextField.text = selectedRecipe.instructions
        categoryTextField.text = selectedRecipe.category?.name
        image.image = (selectedRecipe.image as! UIImage)
    }
    
    func setAllDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        nameTextField.delegate = self
        timeTextField.delegate = self
        descriptionTextField.delegate = self
        instructionsTextField.delegate = self
        categoryTextField.delegate = self
        navigationController?.delegate = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }
    
    //MARK: - IBActions
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        selectedRecipe.name = nameTextField.text!
        selectedRecipe.prepTime = timeTextField.text!
        selectedRecipe.descript = descriptionTextField.text!
        selectedRecipe.instructions = instructionsTextField.text!
        loadCategories()
        if let category = categories.first(where: { $0.name == categoryTextField.text! }) {
            selectedRecipe.category = category
        }
        
        for i in ingredientList {
            set.insert(i)
        }

        selectedRecipe.ingredients = set as NSSet
        Constants.save()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Data manipulation methods
    
    func loadCategories() {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            categories = try Constants.context.fetch(request)
        } catch {
            debugPrint("Error fetching data from context: \(error)")
        }
    }
    
}
//MARK: - Text field delegate methods
extension EditVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let ingedient = ingredientList.first { $0.amount == textField.text! }
        editedIngredient = ingedient
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editedIngredient?.amount = textField.text!
    }
}

//MARK: - Table view delegate and data source
extension EditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? EditCell {
            cell.configCell(ingredientList[indexPath.row],indexPath)
            cell.amountTextField.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - Navigation controller delegate methods
extension EditVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let destVC = viewController as? DetailVC {
            destVC.selectedRecipe = selectedRecipe
            destVC.setTextForAllLabels(with: destVC.selectedRecipe)
        }
    }
}
//MARK: - Category picker
extension EditVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func createPicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([doneButton2], animated: false)
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolBar
    }
    
    @objc func closePicker() {
        categoryTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Constants.categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Constants.categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Constants.categories[row]
    }
    
}
