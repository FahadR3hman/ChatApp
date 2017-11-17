//
//  SocketService.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/16/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: basicUrl)!)
    
    func establishConnection() {
        socket.connect()
    }
    func closeConnection() {
        socket.disconnect()
    }
    
    func AddChannel(channelName: String , channelDescription: String , completion: @escaping completionHandler) {
        socket.emit("newChannel", channelName,channelDescription)
        completion(true)
    }
    
    func getChannel (completion : @escaping completionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let ChannelName = dataArray[0] as? String else { return }
            guard let ChannelDescription = dataArray[1] as? String else { return }
            guard let Channelid = dataArray[2] as? String else { return }
            
            let newChannel = Channel(ChannelName: ChannelName, ChannelDescription: ChannelDescription, ChannelId: Channelid)
            
            MessagesService.instance.channels.append(newChannel)
            completion(true)
        }
    }
    
    
}













