//
//  JsonModel.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation

struct JsonModel: Decodable {
    let fruits: [FruitName]?
}
struct FruitName: Decodable {
    let name: String?
}
