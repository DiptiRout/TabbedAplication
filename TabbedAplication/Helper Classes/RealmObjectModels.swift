//
//  RealmObjectModels.swift
//  TabbedAplication
//
//  Created by Muvi on 06/04/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import RealmSwift

class ItemDetailsObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var itemDescription: String = ""
    @objc dynamic var catagory: String = ""
    @objc dynamic var thumbImageName: String = ""
    @objc dynamic var isFavourite: Bool = false
    
    convenience init(id: Int, name: String, itemDescription: String, catagory: String, thumbImageName: String, isFavourite: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.catagory = catagory
        self.thumbImageName = thumbImageName
        self.isFavourite = isFavourite
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class FruitObject: Object {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
