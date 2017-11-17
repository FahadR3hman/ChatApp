//
//  AvatarPickerCell.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/15/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit
enum AvatarType {
    case  dark
    case  light
}

class AvatarPickerCell: UICollectionViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBg()
    }
    
    func configureCell (index: Int , type: AvatarType) {
        if type == AvatarType.dark {
            avatarImage.image = UIImage(named : "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        } else {
            avatarImage.image = UIImage(named : "light\(index)")
            self.layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
    
    func setUpBg () {
        
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
