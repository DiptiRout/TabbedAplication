//
//  ItemDetails.swift
//  TabbedAplication
//
//  Created by Muvi on 01/04/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
struct ItemDetails: Decodable {
    let name: String?
    let itemDescription: String?
    let catagory: String?
    let thumbImageName: String?
    let isFavourite: Bool?
    
    init(name: String, itemDescription: String, catagory: String, thumbImageName:String, isFavourite: Bool) {
        self.name = name
        self.itemDescription = itemDescription
        self.catagory = catagory
        self.thumbImageName = thumbImageName
        self.isFavourite = isFavourite
    }
}
