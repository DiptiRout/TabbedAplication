//
//  TemperatureViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class TemperatureViewController: UITableViewController {

    let tempUnitArray = ["Farenheit", "Celcius"]
    var indexNumber = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Temperature"
        self.tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tempUnitValue = UserDefaults.standard.string(forKey: "TempUnit") ?? "Celcius"
        cell.textLabel?.text = tempUnitArray[indexPath.row]
        if cell.textLabel?.text == tempUnitValue {
            indexNumber = indexPath.row
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(tempUnitArray[indexPath.row], forKey: "TempUnit")
        if indexNumber != indexPath.row {
            let ip = IndexPath(row: indexNumber, section: 0)
            tableView.cellForRow(at: ip as IndexPath)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        indexNumber = indexPath.row
        print(indexNumber)
    }
}
