//
//  UserEntity+CoreDataProperties.swift
//  goraInterviewTask
//
//  Created by Khurshed Umarov on 03.02.2022.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var name: String?

}

extension UserEntity : Identifiable {

}
