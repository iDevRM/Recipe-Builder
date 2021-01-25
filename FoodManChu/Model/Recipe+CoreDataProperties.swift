//
//  Recipe+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/25/21.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var descript: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var instructions: String?
    @NSManaged public var name: String?
    @NSManaged public var prepTime: Double
    @NSManaged public var category: NSSet?
    @NSManaged public var ingredients: NSSet?

}

// MARK: Generated accessors for category
extension Recipe {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: Categories)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: Categories)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

// MARK: Generated accessors for ingredients
extension Recipe {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredients)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredients)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

extension Recipe : Identifiable {

}
