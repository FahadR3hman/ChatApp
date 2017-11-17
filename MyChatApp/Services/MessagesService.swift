//
//  MessagesService.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/16/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesService {
    
    static let instance = MessagesService()
    
    var channels = [Channel]()
    var selectedChannel : Channel?
    
    func findAllChannels (completion : @escaping completionHandler) {
        let auth = "Bearer " + AuthService.instance.AuthToken
        print(auth)
        print(channelUrl)
        let headers: HTTPHeaders = [
            "Authorization" : auth,
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        Alamofire.request(channelUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                if let json = JSON (data:data).array {
                    print(json.count)
                    for item in json {
                        let name = item["name"].stringValue
                        let desc = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(ChannelName: name, ChannelDescription: desc, ChannelId: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: channels_did_load, object: nil)
                    completion(true)
                }
               
                
            } else {
                completion(false)
                debugPrint(response.result.debugDescription)
            }
        }
    }
    
    func ClearChannels () {
        channels.removeAll()
    }
}
