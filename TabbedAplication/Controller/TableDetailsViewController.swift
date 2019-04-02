//
//  TableDetailsViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class TableDetailsViewController: UIViewController {

    @IBOutlet weak var editTextField: UITextField!
    var textIn = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        editTextField.text = textIn
        // Do any additional setup after loading the view.
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(self.isEditing) {
        }
        else {
        }
    }

}
