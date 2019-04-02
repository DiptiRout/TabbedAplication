//
//  ItemSegmentViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift

class ItemSegmentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items = [ItemDetails]()
    let dbManager = DataBaseManager()
    var itemsData: Results<ItemDetailsObject>!
  
    var segmentSelection = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.CellID)
        
        if segmentSelection == 0 {
            itemsData = dbManager.realm.objects(ItemDetailsObject.self)

        }else if segmentSelection == 1 {
            let predicate = NSPredicate(format: "catagory CONTAINS[cd] %@", "Catagory A")
            itemsData = dbManager.realm.objects(ItemDetailsObject.self).filter(predicate)
            
        }else if segmentSelection == 2 {
            let predicate = NSPredicate(format: "catagory CONTAINS[cd] %@", "Catagory B")
            itemsData = dbManager.realm.objects(ItemDetailsObject.self).filter(predicate)
        }
        else {
            itemsData = dbManager.realm.objects(ItemDetailsObject.self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

}

extension ItemSegmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.CellID, for: indexPath) as! ItemCell
        cell.item = itemsData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
