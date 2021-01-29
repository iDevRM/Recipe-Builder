//
//  Ingredient+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/28/21.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var amount: String?
    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
