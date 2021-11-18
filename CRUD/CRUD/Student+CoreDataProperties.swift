//
//  Student+CoreDataProperties.swift
//  CRUD
//
//  Created by Noura Alahmadi on 11/04/1443 AH.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?

}

extension Student : Identifiable {

}
