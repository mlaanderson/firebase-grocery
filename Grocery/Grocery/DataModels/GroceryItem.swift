//
//  GroceryItem.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/21/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Purchase {
    var date: Int
    var quantity: Double
    var cost: Double
    var total: Double {
        get {
            return cost * quantity
        }
    }
    
    func toJSON() -> [String:Any] {
        var rec: [String:Any] = [:]
        rec["date"] = date
        rec["quantity"] = quantity
        rec["cost"] = cost
        return rec
    }
}

class GroceryItem: GroceryRecord {
    var name: String
    var category: String
    var units: String
    var purchases: [Purchase]
    var store: String?
    var tax: Double = 0
    
    required init?(_ snapshot: DataSnapshot) {
        name = ""
        category = ""
        units = ""
        purchases = [Purchase]()
        
        super.init(snapshot)
        
        if self.fromJSON(snapshot.value) == false { return nil }
    }
    
    required init?(data: AnyObject) {
        name = ""
        category = ""
        units = ""
        purchases = [Purchase]()

        super.init(data: data)
        
        if self.fromJSON(data) == false { return nil }
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
        
        if let purchases = record["purchases"] as? [[String: Any]]{
            for purchase in purchases {
                self.purchases.append(Purchase(
                    date: purchase["date"] as? Int ?? 0,
                    quantity: purchase["quantity"] as? Double ?? 0,
                    cost: purchase["cost"] as? Double ?? 0
                ))
            }
        }
        
        return true
    }
    
    override func toJSON() -> [String : Any] {
        var result : [String : Any] = [:]
        
        result["name"] = self.name
        result["category"] = self.category
        result["units"] = self.units == "ea" ? nil : self.units
        result["store"] = self.store
        result["tax"] = self.tax
        
        result["purchases"] = self.purchases.map({ $0.toJSON() })
        
        return result
    }
}
