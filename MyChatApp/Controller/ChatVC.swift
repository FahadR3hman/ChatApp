//
//  ChatVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var sliderMenu: UIButton!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        sliderMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: Notif_user_data_did_change, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.channelSelected(_:)), name: channel_selected, object: nil)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
      
    }

    override func viewDidAppear(_ animated: Bool) {
        if (AuthService.instance.isLoggedIn) {
            
            AuthService.instance.FindUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notif_user_data_did_change, object: nil)
                
            })
            
            MessagesService.instance.findAllChannels(completion: { (success) in
                
            })
        }
    }
    
    @objc func userDataDidChange (_ notif : Notification) {
        if AuthService.instance.isLoggedIn {
            
        } else {
            channelNameLbl.text = "Please Login"
        }
        
    }
    @objc func channelSelected (_ notif : Notification) {
      updateWithChannel()
        
    }
    
    func updateWithChannel() {
        let channelName = MessagesService.instance.selectedChannel?.ChannelName ?? ""
        channelNameLbl.text = "#\(channelName)"
        
    }
    func onLoginGetMessages() {
        MessagesService.instance.findAllChannels { (success) in
            if success {
                
            }
        }
    }
    
}






