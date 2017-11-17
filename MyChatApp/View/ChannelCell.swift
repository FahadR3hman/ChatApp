//
//  ChannelCell.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/16/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    @IBOutlet weak var ChannelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
        // Configure the view for the selected state
    }

    func configureCell (channel: Channel) {
        let title = channel.ChannelName ?? ""
        ChannelName.text = "#\(title)"
    }
}









