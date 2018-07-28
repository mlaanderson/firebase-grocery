//
//  GroceryRecord.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/21/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroceryRecord {
    var ref: DatabaseReference?
   
    var id: String? { return ref?.key }
    
    required init?(_ snapshot: DataSnapshot) {
        self.ref = snapshot.ref
    }

    required init?(data: AnyObject) {
        self.ref = nil
    }
    
    func toJSON() -> [String:Any] {
        return [:]
    }
}
