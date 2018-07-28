//
//  GroceryList.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/22/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroceryList: GroceryRecord {
    var date: Int = Int(NSDate().timeIntervalSince1970 * 1000)
    var budget: Double = 0
    
    required init?(_ snapshot: DataSnapshot) {
        super.init(snapshot)
        
        // load
        if fromJSON(snapshot.value) == false { return nil }
    }
    
    required init?(data: AnyObject) {
        super.init(data: data)
        
        // load
        if fromJSON(data) == false { return nil }
    }
    
    func fromJSON(_ value: Any?) -> Bool {
        guard
        let record = value as AnyObject?,
        let date = record["date"] as? Int,
        let budget = record["budget"] as? Double
            else { return false }
        
        self.date = date
        self.budget = budget
        
        return true
    }
    
    override func toJSON() -> [String : Any] {
        var result: [String : Any] = [:]
        
        result["date"] = self.date
        result["budget"] = self.budget
        
        return result
    }
}
