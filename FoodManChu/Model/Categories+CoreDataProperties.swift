//
//  Categories+CoreDataProperties.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var recipe: Recipe?

}

extension Categories : Identifiable {

}
