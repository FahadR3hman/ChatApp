//
//  ChatVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class ChatVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var sliderMenu: UIButton!
    
    @IBOutlet weak var typingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageOutlet: UIButton!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    var isTyping = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()
          let tapToClose = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        view.addGestureRecognizer(tapToClose)
        sliderMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: Notif_user_data_did_change, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.channelSelected(_:)), name: channel_selected, object: nil)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
      
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        sendMessageOutlet.isHidden = true
       
        SocketService.instance.getChatMessage { (success) in
            if (success) {
                self.tableView.reloadData()
                if (MessagesService.instance.messages.count > 0) {
                    let indexx = IndexPath.init(row: MessagesService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexx, at: .bottom, animated: true)
                }
            }
        }
        SocketService.instance.getTypingUser { (typingUsers) in
            guard let channelid = MessagesService.instance.selectedChannel?.ChannelId  else {
                return
            }
            var names  = ""
            var numOfTypers = 0
            for (typinguser , channel) in typingUsers {
                if (typinguser != UserDataService.instance.Name && channel == channelid) {
                    if (names == ""){
                        names = typinguser
                    } else {
                        names = "\(names) , \(typinguser)"
                    }
                    numOfTypers += 1
                }
            }
            
            if (numOfTypers > 0 && AuthService.instance.isLoggedIn) {
                var verb = "is"
                if numOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingLbl.text = "\(names)  \(verb) typing..."
            } else {
                 self.typingLbl.text = ""
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if (AuthService.instance.isLoggedIn) {
            
            AuthService.instance.FindUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: Notif_user_data_did_change, object: nil)
                
            })
            
             onLoginGetMessages()
//            MessagesService.instance.findAllChannels(completion: { (success) in
//
//            })
        }
       
    }
    
    @objc func userDataDidChange (_ notif : Notification) {
        if AuthService.instance.isLoggedIn {
            
        } else {
            channelNameLbl.text = "Please Login"
            tableView.reloadData()
        }
        
    }
    @objc func channelSelected (_ notif : Notification) {
      updateWithChannel()
        
    }
    
    func updateWithChannel() {
        let channelName = MessagesService.instance.selectedChannel?.ChannelName ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
        
    }
    func onLoginGetMessages() {
        MessagesService.instance.findAllChannels { (success) in
            if success {
                if MessagesService.instance.channels.count > 0 {
                    MessagesService.instance.selectedChannel = MessagesService.instance.channels[0]
                    self.updateWithChannel()
                }
                    else {
                        self.channelNameLbl.text = "No Channels Yet"
                    }
            }
        }
    }
    
    func getMessages () {
        guard let channelid = MessagesService.instance.selectedChannel?.ChannelId  else {
            return
        }
        MessagesService.instance.findAllMessagesByChannel(channelId: (channelid), completion: { (success) in
            if (success) {
                self.tableView.reloadData()
                
            }
        })
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelid = MessagesService.instance.selectedChannel?.ChannelId  else {
                return
            }
            guard let message = messageTextField.text , messageTextField.text != ""  else {
                return
            }
            
            print(UserDataService.instance.id)
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelid, completion: { (success) in
                if (success) {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                    
                    
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.Name , channelid)
                    
                }
                
                
            })
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as? MessageCell
        let message = MessagesService.instance.messages[indexPath.row]
        cell?.configureCell(message: message)
        return cell!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessagesService.instance.messages.count
    }
    
    @IBAction func HideButton(_ sender: Any) {
        guard let channelid = MessagesService.instance.selectedChannel?.ChannelId  else {
            return
        }
        if (messageTextField.text == "") {
            isTyping = false
            sendMessageOutlet.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.Name , channelid)
        } else {
            if isTyping == false {
                sendMessageOutlet.isHidden = false
                SocketService.instance.socket.emit("startType", UserDataService.instance.Name , channelid)
            }
            isTyping = true
        }
    }
    
    @objc func closeTap (_ recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}











