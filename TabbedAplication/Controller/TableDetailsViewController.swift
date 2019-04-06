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
        editTextField.delegate = self
        editTextField.text = textIn
        editTextField.isUserInteractionEnabled = false
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(self.isEditing) {
            editTextField.isUserInteractionEnabled = true
            editButtonItem.title = "Save"
        }
        else {
            editTextField.isUserInteractionEnabled = false
            editButtonItem.title = "Edit"
            let trimmedName = (editTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if isValidFruitName(newName: trimmedName, storedName: textIn) {
                RealmManager.shared.editObjects(objs: FruitObject(key: textIn, name: trimmedName))
                NotificationCenter.default.post(name: .realmObjectUpdated, object: nil)

            }
        }
    }
    
    func isValidFruitName(newName: String, storedName: String) -> Bool {
        if newName.count > 1 && newName != storedName {
            print("OK")
            return true
        }
        else {
            print("not OK")
            return false
        }
    }
}

extension TableDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
