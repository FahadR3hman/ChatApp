//
//  MessageCell.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/20/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userAvatar: ImageCircle!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var userMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (message : Message) {
        userAvatar.image = UIImage(named: message.userAvatar)
        userAvatar.backgroundColor = UserDataService.instance.returnUIColor(components:message.userAvatarColor)
        userName.text = message.userName
        let time = UserDataService.instance.changeDate(components: message.TimeStamp)
       timeStamp.text = time
        userMessage.text = message.message
    }

}
