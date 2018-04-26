//
//  RecyclingSpot+CoreDataProperties.swift
//  RecycleWhere
//
//  Created by iosdev on 25.04.18.
//  Copyright © 2018 Staham Nguyen. All rights reserved.
//
//

import Foundation
import CoreData


extension RecyclingSpot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecyclingSpot> {
        return NSFetchRequest<RecyclingSpot>(entityName: "RecyclingSpot")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var material_id: String?
    @NSManaged public var name: String?
    @NSManaged public var spot_id: String?

}
