//
//  AddVC.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/16/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit

class AddVC: UIViewController {
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var addChannelField: UITextField!
    
    @IBOutlet weak var addDescField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapToClose = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(tapToClose)
    }

   
    
    @IBAction func dismiss(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    @IBAction func addChannell(_ sender: Any) {
        guard let addchannel = addChannelField.text, addChannelField.text != "" else {
            return
        }
        guard let addchannelDesc = addDescField.text, addDescField.text != "" else {
            return
        }
        
        SocketService.instance.AddChannel(channelName: addchannel, channelDescription: addchannelDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    @objc func closeTap (_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    

}
