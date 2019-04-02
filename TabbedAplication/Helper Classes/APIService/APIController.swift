//
//  APIController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class APIController: NSObject {
    static let shared = APIController()
    func readLocalJSON() -> [FruitName] {
        if let path = Bundle.main.path(forResource: "tabbed", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(JsonModel.self, from: data)
                return jsonData.fruits ?? []
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
