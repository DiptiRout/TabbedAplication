//
//  TableViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var filteredFruitList = [FruitObject]()
    var fruitData = [FruitObject]()
    let searchController = UISearchController(searchResultsController: nil)
    private var observer: NSObjectProtocol!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        guard let items = RealmManager.shared.getObjects(type: FruitObject.self)?.toArray(type: FruitObject.self) else {
            return
        }
        fruitData = items
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.observer = NotificationCenter.default.addObserver(forName: .realmObjectCreated, object: nil, queue: .main) { [weak self] notification in
            
            guard let items = RealmManager.shared.getObjects(type: FruitObject.self)?.toArray(type: FruitObject.self) else {
                return
            }
            self?.fruitData = items
            
            self?.tableView.beginUpdates()
            self?.tableView.insertRows(at: [IndexPath.init(row: (self?.fruitData.count ?? 0)-1, section: 0)], with: .automatic)
            self?.tableView.endUpdates()
        }
        self.observer = NotificationCenter.default.addObserver(forName: .realmObjectUpdated, object: nil, queue: .main) { [weak self] notification in
            
            self?.tableView.reloadData()
        }
   
    }
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
   
    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.clipsToBounds = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    @objc func addBarButtonTapped()  {
        
        let name = randomString(length: 5)
        RealmManager.shared.saveObjects(objs: FruitObject(key: name, name: name))
        //fruitData.append(FruitObject(name: name))
        NotificationCenter.default.post(name: .realmObjectCreated, object: nil)
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(self.isEditing) {
            tableView.allowsMultipleSelectionDuringEditing = true
            editButtonItem.title = "Delete"
            self.navigationItem.title = "0 Selected"

        }
        else {
            editButtonItem.title = "Edit"
            self.navigationItem.title = "Table"
            deleteRows()
        }
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    func deleteRows() {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var items = [FruitObject]()
            for indexPath in selectedRows  {
                items.append(fruitData[indexPath.row])
            }
            for item in items {
                RealmManager.shared.deleteObject(objs: item)
                fruitData = fruitData.filter({ (fruit) -> Bool in
                    !fruit.isInvalidated
                })
            }
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: selectedRows, with: .automatic)
            self.tableView.endUpdates()
          
        }
    }
   
}
extension TableViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredFruitList.count
        }
        else {
            return fruitData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        if searchController.isActive {
            cell.textLabel?.text = filteredFruitList[indexPath.row].name
        }else {
            cell.textLabel?.text = fruitData[indexPath.row].name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.dismiss(animated: true, completion: nil)
        if tableView.isEditing {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                self.navigationItem.title = "\(selectedRows.count) Selected"
            }
        }
        else {
            let storyboard = UIStoryboard(name: "TabbedMain", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "TableDetailsVC") as! TableDetailsViewController
            if searchController.isActive {
                destination.textIn = filteredFruitList[indexPath.row].name
            }
            else {
                destination.textIn = fruitData[indexPath.row].name
            }
            navigationController?.pushViewController(destination, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            if let selectedRows = tableView.indexPathsForSelectedRows {
                self.navigationItem.title = "\(selectedRows.count) Selected"
            }
            else{
                self.navigationItem.title = "0 Selected"
            }
        }
    }
}

extension TableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterTableViewForEnterText(searchText: searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }
    
    func filterTableViewForEnterText(searchText: String) {
        filteredFruitList = fruitData.filter({ (fruit) -> Bool in
            fruit.name.localizedCaseInsensitiveContains(searchText)
        })
        self.tableView.reloadData()
    }
//    func willDismissSearchController(_ searchController: UISearchController) {
//        tableView.didsele
//    }
}
