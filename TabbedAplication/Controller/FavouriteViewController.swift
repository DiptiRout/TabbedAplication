//
//  FavouriteViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteViewController: UIViewController {

    var items = [ItemDetails]()
    var itemObject = List<ItemDetailsObject>()
    let dbManager = DataBaseManager()
    var itemsData: Results<ItemDetailsObject>!
    
    private var observer: NSObjectProtocol!

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let predicate = NSPredicate(format: "isFavourite == YES")
        itemsData = dbManager.realm.objects(ItemDetailsObject.self).filter(predicate)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        observer = NotificationCenter.default.addObserver(forName: .globalVariableChanged, object: nil, queue: .main) { [weak self] notification in
            
            self?.tableView.reloadData()
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.item = itemsData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}

