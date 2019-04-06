//
//  RealmManager.swift
//  TabbedAplication
//
//  Created by Muvi on 06/04/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager {
    private var realm : Realm?
    static let shared = RealmManager()
    
    private init() {
        realm = try! Realm()
    }
    // delete
    func deleteDatabase() {
        try! realm?.write({
            realm?.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(objs : Object) {
        try? realm!.write ({
            realm?.delete(objs)
        })
    }
    
    //Save array of objects to database
    func saveObjects(objs: Object) {
        try? realm!.write ({
            // If update = false, adds the object
            realm?.add(objs, update: false)
        })
    }
    func saveListObject(list: [Object]) {
        try? realm!.write ({
            // If update = false, adds the object
            realm?.add(list, update: false)
        })
    }
    
    // editing the object
    func editObjects(objs: Object) {
        try? realm!.write ({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm?.add(objs, update: true)
        })
    }
    
    //Returs an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm!.objects(type)
    }
    
//    func incrementID() -> Int {
//        return (realm!.objects(Person.self).max(ofProperty: "id") as Int? ?? 0) + 1
//    }
    
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
