//
//  AppDelegate.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var itemObject = List<ItemDetailsObject>()
    let dbManager = DataBaseManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        loadData()
        loadFruitNames()
        return true
    }
    
    func loadData() {
        let itemsData = dbManager.realm.objects(ItemDetailsObject.self)
        if itemsData.isEmpty {
            itemObject.append(dbManager.makeNewItem("Item Name 1", itemDescription: "Item Description", catagory: "Item Catagory A", thumbImageName: "user.png", isFavourite: false))
            itemObject.append(dbManager.makeNewItem("Item Name 2", itemDescription: "Item Description", catagory: "Item Catagory B", thumbImageName: "user.png", isFavourite: false))
            itemObject.append(dbManager.makeNewItem("Item Name 3", itemDescription: "Item Description", catagory: "Item Catagory A", thumbImageName: "user.png", isFavourite: false))
            itemObject.append(dbManager.makeNewItem("Item Name 4", itemDescription: "Item Description", catagory: "Item Catagory B", thumbImageName: "user.png", isFavourite: false))
            itemObject.append(dbManager.makeNewItem("Item Name 5", itemDescription: "Item Description", catagory: "Item Catagory A", thumbImageName: "user.png", isFavourite: false))
            itemObject.append(dbManager.makeNewItem("Item Name 6", itemDescription: "Item Description", catagory: "Item Catagory B", thumbImageName: "user.png", isFavourite: false))
            
            do {
                try dbManager.saveListObject(itemObject)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadFruitNames() {
        do {
            let fruits = APIController.shared.readLocalJSON()
            let _ = try fruits.map{
                let object = try dbManager.findFruitByName(name: $0.name ?? "")
                if object.isEmpty {
                    dbManager.saveFruits(name: $0.name ?? "")
                }
            }

        } catch let error {
            print(error)
        }

        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

