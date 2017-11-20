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
    
    func addMessage (messageBody: String , userId: String , channelId: String , completion : @escaping completionHandler ) {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody , userId , channelId , user.Name , user.AvatarName , user.avatarColor)
        completion(true)
    }
    
    func getChatMessage (completion : @escaping completionHandler ) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else { return }
            guard let Channelid = dataArray[2] as? String else { return }
            guard let  userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
             guard let  id = dataArray[6] as? String else { return }
            guard let  timeStamp = dataArray[7] as? String else { return }
            
             //guard let  msgId = dataArray[1] as? String else { return }
            
            if ( Channelid == MessagesService.instance.selectedChannel?.ChannelId && AuthService.instance.isLoggedIn ) {
                let newMessage = Message(message: msgBody, userName: userName, ChannelId: Channelid, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, TimeStamp: timeStamp)
                MessagesService.instance.messages.append(newMessage)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func getTypingUser(_ completionHandler : @escaping (_ typingUsers : [String: String]) -> Void){
        socket.once("userTypingUpdate") { (dataArray, ack) in
             guard let typinguser = dataArray[0] as? [String: String] else { return }
            completionHandler(typinguser)
        }
        
    }
}


















