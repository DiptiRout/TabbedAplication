//
//  DataBaseManager.swift
//  NewsFeedsPractical
//
//  Created by Muvi on 12/02/19.
//  Copyright © 2019 Dipti. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


public class ItemDetailsObject: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var itemDescription = ""
    @objc dynamic var catagory = ""
    @objc dynamic var thumbImageName = ""
    @objc dynamic var isFavourite: Bool = false

}

class FruitObject: Object {
    @objc dynamic var name: String = ""
}

public class DataBaseManager {
    public init() {
    }
    var realm: Realm = try! Realm()
    
    func saveFruits(name: String) {
        let newFruit = FruitObject()
        newFruit.name = name
        try! realm.write {
            realm.add(newFruit)
        }
    }
    func findFruitByName(name: String) throws -> Results<FruitObject>
    {
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(FruitObject.self).filter(predicate)
        
    }
    
    func removeFruit(_ item: String) throws {
        
        let predicate = NSPredicate(format: "name == %@", item)
        let targetItem = realm.objects(FruitObject.self).filter(predicate)
        var objects = targetItem.makeIterator()
        while let object = objects.next() {
            try! realm.write {
                realm.delete(object)
            }
        }
        
    }
    
    public func makeNewItem(_ name: String, itemDescription: String, catagory: String, thumbImageName: String, isFavourite: Bool ) -> ItemDetailsObject
    {
        let newItem = ItemDetailsObject()
        newItem.name = name
        newItem.itemDescription = itemDescription
        newItem.catagory = catagory
        newItem.isFavourite = isFavourite
        newItem.thumbImageName = thumbImageName
        return newItem
    }
    
    public func saveListObject(_ object: List<ItemDetailsObject>) throws
    {
        try! realm.write {
            realm.add(object)

        }
    }
    public func findItemByName(_ name: String) throws -> Results<ItemDetailsObject>
    {
        let predicate = NSPredicate(format: "name = %@", name)
        return realm.objects(ItemDetailsObject.self).filter(predicate)
        
    }
//    public func updateItem(isFav: Bool, name: String) {
//        let realm = try! Realm()
//        let predicate = NSPredicate(format: "name == %@", name)
//        let item = realm.objects(ItemDetailsObject.self).filter(predicate).first
//
//        try! realm.write {
//            item?.isFavourite = isFav
//        }
//    }
    
    public func updateItem(isFav: Bool, name: String, completion: (_ isSuccess: Bool) -> Void) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name == %@", name)
        let item = realm.objects(ItemDetailsObject.self).filter(predicate).first
        try! realm.write {
            item?.isFavourite = isFav
            NotificationCenter.default.post(name: .globalVariableChanged, object: nil)
            completion(true)
        }
    }
    
    
    public func deleteItem(_ item: ItemDetailsObject) throws {
        
        let predicate = NSPredicate(format: "name == %@", item.name)
        let targetItem = realm.objects(ItemDetailsObject.self).filter(predicate)
        var objects = targetItem.makeIterator()
        while let object = objects.next() {
            try! realm.write {
                realm.delete(object)
            }
        }
        
    }
}
