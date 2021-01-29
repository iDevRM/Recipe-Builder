//
//  Ingredients+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/28/21.
//
//

import Foundation
import CoreData


extension Ingredients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredients> {
        return NSFetchRequest<Ingredients>(entityName: "Ingredients")
    }

    @NSManaged public var amount: String?
    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Ingredients : Identifiable {

}
