//
//  GroceryListItem.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/22/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroceryListItem: GroceryRecord {
    var name: String
    var category: String
    var units: String = "ea"
    var store: String?
    var tax: Double = 0
    var cost: Double = 0
    var quantity: Double = 0
    var purchased: Bool = false
    
    required init?(_ snapshot: DataSnapshot) {
        name = ""
        category = ""
        
        super.init(snapshot)
        
        if self.fromJSON(snapshot.value) == false { return nil }
    }
    
    required init?(data: AnyObject) {
        name = ""
        category = ""
        
        super.init(data: data)
        
        if self.fromJSON(data) == false { return nil }
    }
    
    init(item: GroceryItem) {
        name = item.name
        category = item.category
        units = item.units
        store = item.store
        tax = item.tax
        cost = item.purchases.last?.cost ?? 0
        quantity = item.purchases.last?.quantity ?? 0
        purchased = false
        
        super.init(data: [:] as AnyObject)!
    }
    
    func fromJSON(_ value: Any?) -> Bool {
        guard
        let record = value as AnyObject?,
        let name = record["name"] as? String,
        let category = record["category"] as? String
            else { return false }
        
        self.name = name
        self.category = category
        self.units = record["units"] as? String ?? "ea"
        self.store = record["store"] as? String
        self.tax = record["tax"] as? Double ?? 0
        self.cost = record["cost"] as? Double ?? 0
        self.purchased = record["purchase"] as? Bool ?? false
        
        return true
    }
    
    override func toJSON() -> [String : Any] {
        var result : [String : Any] = [:]
        
        result["name"] = self.name
        result["category"] = self.category
        result["units"] = self.units == "ea" ? nil : self.units
        result["store"] = self.store
        result["tax"] = self.tax
        result["cost"] = self.cost
        result["purchased"] = self.purchased
        
        return result
    }
}
