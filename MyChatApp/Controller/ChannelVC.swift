//
//  ChannelVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: ImageCircle!
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 70
        self.revealViewController().frontViewShadowColor = UIColor.red
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_ :)), name: Notif_user_data_did_change, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(channalesDidLoad(_:)), name: channels_did_load, object: nil)
        
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setUpUserInfo()
     
       
    }
    
    @IBAction func AddChannel(_ sender: Any) {
        print("abc")
        if (AuthService.instance.isLoggedIn) {
        let add = AddVC()
        add.modalPresentationStyle = .custom
        present(add, animated: true, completion: nil)
        } else {
            
        }

    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        if (AuthService.instance.isLoggedIn) {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
        performSegue(withIdentifier: To_Login, sender: nil)
        }
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
    
    @objc func userDataDidChange (_ notif : Notification) {
        self.setUpUserInfo()
        
    }
    @objc func channalesDidLoad (_ notif : Notification) {
        
         self.tableView.reloadData()
    }
    func setUpUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(UserDataService.instance.Name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.AvatarName)
            userImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }
        else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channel", for: indexPath) as? ChannelCell
       let channel = MessagesService.instance.channels[indexPath.row]
        cell?.configureCell(channel: channel)
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesService.instance.channels.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessagesService.instance.channels[indexPath.row]
        MessagesService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: channel_selected, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
}










