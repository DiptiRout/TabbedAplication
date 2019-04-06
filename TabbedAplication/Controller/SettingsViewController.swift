//
//  SettingsViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

struct SettingData: Decodable {
    var tempUnit: String
    var sound: String
    var notification: String
    var probationDateEnd: String
}

class SettingsViewController: UITableViewController {

    var settingData: SettingData!
    private var datePicker: UIDatePicker?

    // MARK: - Static Cell Outlets
    @IBOutlet weak var tempUnit: UILabel!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var probationEndTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        UserDefaults.standard.set(tempUnit.text ?? "Celcius", forKey: "TempUnit")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tempUnitValue = UserDefaults.standard.string(forKey: "TempUnit") ?? "Celcius"
        
        settingData = SettingData(tempUnit: tempUnitValue, sound: "\(soundSwitch.isOn)".capitalized, notification: "\(notificationSwitch.isOn)".capitalized, probationDateEnd: probationEndTF.placeholder ?? "01/01/2019")
        tempUnit.text = tempUnitValue
    }
    
    @IBAction func soundState(_ sender: UISwitch) {
        settingData.sound = "\(sender.isOn)".capitalized
    }
    @IBAction func notificationState(_ sender: UISwitch) {
        settingData.notification = "\(sender.isOn)".capitalized
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "TabbedMain", bundle: nil)
        if indexPath.section == 0 && indexPath.row == 0 {
            let destination = storyboard.instantiateViewController(withIdentifier: "TemperatureVC") as! TemperatureViewController
            navigationController?.pushViewController(destination, animated: false)
        }
        else if indexPath.section == 2 && indexPath.row == 0 {
            let destination = storyboard.instantiateViewController(withIdentifier: "ViewDetailsVC") as! ViewDetailsViewController
            destination.title = "View Details"
            destination.settingData = self.settingData
            navigationController?.pushViewController(destination, animated: false)
        }
    }
    private func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        probationEndTF.inputAccessoryView = toolBar
        probationEndTF.inputView = datePicker
    }
    @objc func doneClick() {
        probationEndTF.resignFirstResponder()
    }
    @objc func cancelClick() {
        probationEndTF.resignFirstResponder()
    }
    @objc func dateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        probationEndTF.placeholder = formatter.string(from: sender.date)
        settingData.probationDateEnd = formatter.string(from: sender.date)
        view.endEditing(true)
    }
}
