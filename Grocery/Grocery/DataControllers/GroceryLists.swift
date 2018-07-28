//
//  GroceryLists.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/22/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

class GroceryLists {
    var ref: DatabaseReference
    var root: DatabaseReference
    var produce: GroceryItems
    var list: GroceryList?
    var listItems: GroceryListItems?
    
    init(_ ref: DatabaseReference) {
        self.ref = ref
        self.root = ref.parent!
        
        self.produce = GroceryItems(root.child("items"))
        
        ref.observeSingleEvent(of: .value) { snapshot in
            self.list = GroceryList(snapshot)
            self.listItems = GroceryListItems(snapshot.ref.child("items"))
            
            self.listItems?.loadRecords() { _ in
                
            }
        }
    }
}
