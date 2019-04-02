//
//  ViewDetailsViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class ViewDetailsViewController: UITableViewController {

    var settingData: SettingData!
    let formatter = DateFormatter()

    // MARK: - Static Cell Outlets
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var dateOfJoining: UILabel!
    @IBOutlet weak var tempDisplayUnit: UILabel!
    @IBOutlet weak var sound: UILabel!
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var dateProbationEnds: UILabel!
    @IBOutlet weak var probationDuration: UILabel!
    @IBOutlet weak var datePermanent: UILabel!
    @IBOutlet weak var probationLenght: UILabel!
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.text = "Naruto"
        email.text = "naruto@u.com"
        dateOfJoining.text = "01/01/2017"
        tempDisplayUnit.text = settingData.tempUnit
        sound.text = settingData.sound
        notification.text = settingData.notification
        dateProbationEnds.text = settingData.probationDateEnd
        
        let value = setUpDuration()
        
        probationDuration.text = value.duration
        datePermanent.text = "01/07/2019"
        probationLenght.text = value.length

    }
    
    func setUpDuration() -> (duration: String, length: String) {
        formatter.dateFormat = "dd/MM/yyyy"
        let doj = formatter.date(from: dateOfJoining.text ?? "")
        let dope = formatter.date(from: dateProbationEnds.text ?? "")
        
        if let date1 = doj, let date2 = dope {
            let months = date2.months(from: date1)
            let days = date2.days(from: date1) - (months * 30)
            
            if days > 0 {

                return ("\(months) months \(days) days" , "More than \(months) months")
            }
            else {
                return ("\(months) months \(days) days" , "\(months) months")
            }
            
        }
        else {
            return ("X months Y days", "X months")
        }
    }
}
