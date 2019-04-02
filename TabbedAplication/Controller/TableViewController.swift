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
    var filteredFruitList: Results<FruitObject>!
    let dbManager = DataBaseManager()
    var fruitData: Results<FruitObject>!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        fruitData = dbManager.realm.objects(FruitObject.self)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
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
        dbManager.saveFruits(name: name)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath.init(row: fruitData.count-1, section: 0)], with: .automatic)
        self.tableView.endUpdates()
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
        }
        else {
            editButtonItem.title = "Edit"
            deleteRows()
        }
        self.tableView.isEditing = !self.tableView.isEditing
    }
    
    func deleteRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            // 1
            var items = [String]()
            for indexPath in selectedRows  {
                items.append(fruitData[indexPath.row].name)
            }
            // 2
            for item in items {
                let predicate = NSPredicate(format: "name != %@", item)
                fruitData = fruitData.filter(predicate)
            }
            // 3
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
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
}

extension TableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterTableViewForEnterText(searchText: searchController.searchBar.text ?? "")
        self.tableView.reloadData()
    }
    
    func filterTableViewForEnterText(searchText: String) {
        let searchPredicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        filteredFruitList = fruitData.filter(searchPredicate)
        self.tableView.reloadData()
    }
//    func willDismissSearchController(_ searchController: UISearchController) {
//        tableView.didsele
//    }
}
