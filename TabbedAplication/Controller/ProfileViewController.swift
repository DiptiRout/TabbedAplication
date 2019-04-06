//
//  ProfileViewController.swift
//  TabbedAplication
//
//  Created by Muvi on 30/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    private let resizeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        button.clipsToBounds = true
        button.titleLabel?.numberOfLines = 0
        button.setTitle("User's Avatar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private var datePicker: UIDatePicker?
    var imagePicker: ImagePicker!
    
    // MARK: - Static Cell Outlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var hobbyTF: UITextField!
    @IBOutlet weak var dateOfJoinTF: UITextField!
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeAndHandleOrientationMode()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        emailTF.delegate = self
        hobbyTF.delegate = self
        dateOfJoinTF.delegate = self
        setDatePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        moveAndResizeImageForPortrait()
    }
    
    // MARK: - Scroll View Delegates
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        moveAndResizeImageForPortrait()
    }
    
    // MARK: - Private methods
    private func setDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        
        dateOfJoinTF.inputView = datePicker
    }
    @objc func viewTapped(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    @objc func dateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        dateOfJoinTF.text = formatter.string(from: sender.date)
        view.endEditing(true)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(resizeButton)
        resizeButton.anchor(nil, left: nil, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: Const.ImageBottomMarginForLargeState, rightConstant: Const.ImageRightMargin, widthConstant: Const.ImageSizeForLargeState, heightConstant: Const.ImageSizeForLargeState)
        resizeButton.addTarget(self, action: #selector(btnImagePickerClicked(sender:)), for: .touchUpInside)
    }
    
    private func observeAndHandleOrientationMode() {
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: OperationQueue.current) { [weak self] _ in
            
            self?.navigationItem.title = "User Name"
            self?.moveAndResizeImageForPortrait()
        }
    }
    
    private func moveAndResizeImageForPortrait() {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        resizeButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.resizeButton.alpha = show ? 1.0 : 0.0
        }
    }
    
    private func showTutorialAlert() {
        let alert = UIAlertController(title: "Tutorial", message: "Scroll down and up to resize the image in navigation bar.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it!", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc func btnImagePickerClicked(sender: UIButton)
    {
        self.imagePicker.present(from: sender)
    }
   
}

extension ProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.resizeButton.setImage(image, for: .normal)
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isValidated = emailTF.text?.isValidateEmail() ?? false
        if isValidated == true {
            
        }
        else {
            emailTF.shake()
            emailTF.text = ""
            emailTF.placeholder = "Enter valid email"
        }
        
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController {
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 80
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 8
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 8
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 40
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
}
