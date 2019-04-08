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
    var shownIndexes : [IndexPath] = []
    let CELL_HEIGHT : CGFloat = 200
    private var observer: NSObjectProtocol!

  
    var segmentSelection = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
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
        
        self.observer = NotificationCenter.default.addObserver(forName: .realmObjectUpdated, object: nil, queue: .main) { [weak self] notification in
//            guard let items = RealmManager.shared.getObjects(type: ItemDetailsObject.self)?.toArray(type: ItemDetailsObject.self) else {
//                return
//            }
//            self?.itemsData = items.filter({ (item) -> Bool in
//                item.isFavourite == true
//            })
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // tableView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
}

extension ItemSegmentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: CELL_HEIGHT)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(0.5)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
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
