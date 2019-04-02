//
//  ItemCell.swift
//  TabbedAplication
//
//  Created by Muvi on 31/03/19.
//  Copyright © 2019 Naruto. All rights reserved.
//

import Foundation
import UIKit

class ItemCell: UITableViewCell {
    static let CellID = "ItemCell"
    let thumImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let decLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let catagoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let favButton: FaveButton = {
        let fb = FaveButton(
            frame: CGRect(x:0, y:0, width: 44, height: 44),
            faveIconNormal: UIImage(named: "star")
        )
        return fb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpView() {
        contentView.addSubview(thumImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favButton)
        contentView.addSubview(decLabel)
        contentView.addSubview(catagoryLabel)
        
        thumImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, topConstant: 12, leftConstant: 16, bottomConstant: 12, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        favButton.anchor(nil, left: nil, bottom: nil, right: contentView.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 32, widthConstant: 30, heightConstant: 30)
        favButton.anchorCenterYToSuperview()
        favButton.delegate = self
        nameLabel.anchor(contentView.topAnchor, left: thumImageView.rightAnchor, bottom: nil, right: favButton.leftAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        decLabel.anchor(nameLabel.bottomAnchor, left: thumImageView.rightAnchor, bottom: nil, right: favButton.leftAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
        catagoryLabel.anchor(decLabel.bottomAnchor, left: thumImageView.rightAnchor, bottom: nil, right: favButton.leftAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 0)
    }
    
    var item: ItemDetailsObject? {
        didSet {
            if let item = item {
                nameLabel.text = item.name
                decLabel.text = item.itemDescription
                catagoryLabel.text = item.catagory
                if item.isFavourite {
                    favButton.isSelected = true
                }
                else {
                    favButton.isSelected = false
                }
                thumImageView.image = UIImage(named: item.thumbImageName)
            }
        }
    }
}

extension ItemCell: FaveButtonDelegate {
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        let db = DataBaseManager()
        db.updateItem(isFav: selected, name: nameLabel.text ?? "") { (isSuccess) in
            print(isSuccess)
        }
    }
}
