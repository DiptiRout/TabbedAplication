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
    var itemsData = [ItemDetailsObject]()
  
    var segmentSelection = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.CellID)
        
        guard let items = RealmManager.shared.getObjects(type: ItemDetailsObject.self)?.toArray(type: ItemDetailsObject.self) else {
            return
        }
        if segmentSelection == 0 {
            itemsData = items
        }
        else if segmentSelection == 1 {
            itemsData = items.filter({ (item) -> Bool in
                item.catagory.contains("Catagory A")
            })
        }
        else if segmentSelection == 2 {
            itemsData = items.filter({ (item) -> Bool in
                item.catagory.contains("Catagory B")
            })
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
