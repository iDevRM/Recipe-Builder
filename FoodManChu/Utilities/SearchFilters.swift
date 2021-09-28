//
//  SearchFilters.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import Foundation

enum SearchFilters: String {
    case searchByName = "name"
    case searchByDescription = "descript"
    case searchByIngredients = "ingredients.name"
    case searchByTime = "prepTime"
    case searchByCategory = "category.name"
}
