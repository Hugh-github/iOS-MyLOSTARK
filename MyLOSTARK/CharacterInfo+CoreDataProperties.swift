//
//  CharacterInfo+CoreDataProperties.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/02.
//
//

import Foundation
import CoreData


extension CharacterInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterInfo> {
        return NSFetchRequest<CharacterInfo>(entityName: "CharacterInfo")
    }

    @NSManaged public var itemLevel: Float
    @NSManaged public var jobClass: String?
    @NSManaged public var name: String?

}

extension CharacterInfo : Identifiable {

}
