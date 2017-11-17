//
//  LoginVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var userEmailField: UITextField!
    
    @IBOutlet weak var userPasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activity.isHidden = true
    }

    
    @IBAction func Dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Login(_ sender: Any) {
        activity.isHidden = false
        activity.startAnimating()
        guard let emailField = userEmailField.text , userEmailField.text != "" else {
            return
        }
        guard let pass = userPasswordField.text , userPasswordField.text != "" else {
            return
        }
        
        AuthService.instance.login(email: emailField, password: pass) { (success) in
            if (success) {
                AuthService.instance.FindUserByEmail(completion: { (success) in
                    NotificationCenter.default.post(name: Notif_user_data_did_change, object: nil)
                    self.activity.stopAnimating()
                    self.activity.hidesWhenStopped = true
                    self.dismiss(animated: true, completion: nil)
                
                })
            }
        }
    }
    
    @IBAction func SignUp(_ sender: Any) {
        performSegue(withIdentifier: To_SignUp, sender: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}







