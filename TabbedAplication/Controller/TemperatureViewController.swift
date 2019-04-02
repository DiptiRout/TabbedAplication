//
//  TemperatureViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class TemperatureViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Temperature"
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.set("Farenheit", forKey: "TempUnit")
        }
        else {
            UserDefaults.standard.set("Celcius", forKey: "TempUnit")
        }
    }

}
