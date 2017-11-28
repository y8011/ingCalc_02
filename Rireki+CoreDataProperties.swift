//
//  Rireki+CoreDataProperties.swift
//  
//
//  Created by yuka on 2017/11/28.
//
//

import Foundation
import CoreData


extension Rireki {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rireki> {
        return NSFetchRequest<Rireki>(entityName: "Rireki")
    }

    @NSManaged public var result: String?
    @NSManaged public var r_id: Int16
    @NSManaged public var resultText: String?

}
