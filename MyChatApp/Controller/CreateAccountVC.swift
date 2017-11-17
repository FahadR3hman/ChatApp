//
//  CreateAccountVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    //Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var userAvatar: ImageCircle!
    
    var avatarName = ""
    var avatarColor = "[0.5, 0.5, 0.5 ,1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activityIndicator.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
     
        if UserDataService.instance.AvatarName != "" {
            userAvatar.image = UIImage(named: UserDataService.instance.AvatarName )
            if (UserDataService.instance.AvatarName.contains("light")) && bgColor == nil{
                self.userAvatar.backgroundColor = UIColor.darkGray
                
                
            }
            else {
                 self.userAvatar.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func Dismiss(_ sender: Any) {
        performSegue(withIdentifier: to_unwind, sender: nil)
    }

  
    @IBAction func CreateAccount(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let emailField = email.text , email.text != "" else {
            return
        }
        guard let pass = password.text , password.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: emailField, password: pass) { (success) in
            if (success) {
                AuthService.instance.login(email: emailField, password: pass, completion: { (success) in
                    if (success) {
                       // print("logged in successfully" , AuthService.instance.AuthToken)
                        AuthService.instance.createUsers(name:self.userName.text!, email: emailField, avatarName: UserDataService.instance.AvatarName, avatarColor: self.avatarColor,  completion: { (success) in
                            if (success) {
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                
                                self.performSegue(withIdentifier: to_unwind, sender: nil)
                                print("User in successfully" , AuthService.instance.AuthToken)
                                NotificationCenter.default.post(name: Notif_user_data_did_change, object: nil)
                            }
                        })
                    }
                })
            }
        }
    }
    
    @IBAction func GenerateBG(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255) ) / 255
        let green = CGFloat(arc4random_uniform(255) ) / 255
        let blue = CGFloat(arc4random_uniform(255) ) / 255
        
        bgColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        avatarColor = "[\(red) ,\(green), \(blue), 1]"
        UIView.animate(withDuration: 0.2) {
            self.userAvatar.backgroundColor = self.bgColor
        }
        
    }
    
    @IBAction func ChooseAvatar(_ sender: Any) {
        performSegue(withIdentifier: to_avatar_picker, sender: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
