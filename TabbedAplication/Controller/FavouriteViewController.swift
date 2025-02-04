//
//  FavouriteViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialComponents.MaterialSnackbar

class FavouriteViewController: UIViewController {

    var items = [ItemDetails]()
    var itemsData = [ItemDetailsObject]()
    
    private var observer: NSObjectProtocol!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let items = RealmManager.shared.getObjects(type: ItemDetailsObject.self)?.toArray(type: ItemDetailsObject.self) else {
            return
        }
        self.itemsData = items.filter({ (item) -> Bool in
            item.isFavourite == true
        })
        self.tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.observer = NotificationCenter.default.addObserver(forName: .realmObjectUpdated, object: nil, queue: .main) { [weak self] notification in
            guard let items = RealmManager.shared.getObjects(type: ItemDetailsObject.self)?.toArray(type: ItemDetailsObject.self) else {
                return
            }
            self?.itemsData = items.filter({ (item) -> Bool in
                item.isFavourite == true
            })
            self?.tableView.reloadData()
        }
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemsData.count == 0 {
            let message = MDCSnackbarMessage()
            message.text = "There are no favourite data"
            MDCSnackbarManager.show(message)
            return itemsData.count

        }
        else {
            return itemsData.count
        }
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

