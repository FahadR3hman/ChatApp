//
//  ProfileVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/15/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var userImage: ImageCircle!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var userEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userName.text = UserDataService.instance.Name
        userEmail.text = UserDataService.instance.email
        userImage.image = UIImage(named: UserDataService.instance.AvatarName)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let tapToClose = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(tapToClose)
    }

   
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        UserDataService.instance.logOutuser()
        NotificationCenter.default.post(name: Notif_user_data_did_change, object: nil)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func closeTap (_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
