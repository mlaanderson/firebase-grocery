//
//  GroceryRecords.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/22/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum Events : Int {
    case childAdded,
    childChanged,
    childRemoved
}

func emptyStringCompletion(_ arg: String) -> Void {}
func emptyOptStringCompletion(_ arg: String?) -> Void {}

class GroceryRecords<T: GroceryRecord> : Observable<Events, T> {
    let ref: DatabaseReference
    
    init(_ reference: DatabaseReference) {
        self.ref = reference
        super.init()
        
        self.ref.observe(.childAdded, with: self.childAddedHandler)
        self.ref.observe(.childChanged, with: self.childChangedHandler)
        self.ref.observe(.childRemoved, with: self.childRemovedHandler)
    }

    private func childAddedHandler(snapshot: DataSnapshot) {
        if let added = T(snapshot) {
            self.onChildAdded(added)
        }
    }

    private func childChangedHandler(snapshot: DataSnapshot) {
        if let changed = T(snapshot) {
            self.onChildChanged(changed)
        }
    }

    private func childRemovedHandler(snapshot: DataSnapshot) {
        if let removed = T(snapshot) {
            self.onChildRemoved(removed)
        }
    }
    
    func onChildAdded(_ added: T) {
        emit(.childAdded, added)
    }
    
    func onChildChanged(_ changed: T) {
        emit(.childChanged, changed)
    }
    
    func onChildRemoved(_ removed: T) {
        emit(.childRemoved, removed)
    }
    
    private func snapshotToRecords(_ snapshot: DataSnapshot) -> [String:T] {
        var result: [String:T] = [:]
        for child in snapshot.children {
            if let csnap = child as? DataSnapshot {
                let childItem = T(csnap)
                result[csnap.key] = childItem
            }
        }
        return result
    }
    
    func loadRecords(completion:@escaping ([String:T]) -> Void) {
        ref.observeSingleEvent(of: .value) { snapshot in
            completion(self.snapshotToRecords(snapshot))
        }
    }
    
    func searchRecords(child: String, startAt: Any?, endAt: Any?, completion:@escaping ([String:T]) -> Void) {
        var cref = ref.queryOrdered(byChild: child)
        if startAt != nil {
            cref = cref.queryStarting(atValue: startAt)
        }
        if endAt != nil {
            cref = cref.queryEnding(atValue: endAt)
        }
        
        cref.observeSingleEvent(of: .value) { snapshot in
            completion(self.snapshotToRecords(snapshot))
        }
    }
    
    func save(_ record: T) -> String {
        let saveData = record.toJSON()
        if record.ref != nil {
            // updating an existing record
            record.ref!.setValue(saveData)
        } else {
            record.ref = self.ref.childByAutoId()
            record.ref!.setValue(saveData)
        }
        return record.ref!.key
    }
    
    func load(_ key: String, completion:@escaping (T?) -> Void) {
        self.ref.child(key).observeSingleEvent(of: .value) { snapshot in
            guard
                let record = T(snapshot)
                else {
                    completion(nil)
                    return
                }
            completion(record)
        }
    }
    
    func remove(_ record: T, completion:@escaping ((String?) -> Void) = emptyOptStringCompletion) {
        guard record.ref != nil else {
            completion(nil)
            return
        }
        record.ref!.removeValue() { error, reference in
            completion(record.ref?.key)
        }
    }
}
