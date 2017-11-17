//
//  Constants.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/10/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import Foundation

typealias completionHandler = (_ Success : Bool) -> ()

let To_Login = "tologin"

let To_SignUp = "create"

let to_unwind = "unwindtochannel"

let to_avatar_picker = "AvatarPicker"

//
let Token_id = "Token"

let Logged_in_key = "LoggedIn"

let userEmail = "UserEmail"


//URLS

let basicUrl = "https://mychatappios.herokuapp.com/v1/"

let registerUrl = basicUrl + "account/register"

let loginUrl = basicUrl + "account/login"

let AddUserUrl = basicUrl + "user/add"

let findUserByEmail = basicUrl + "user/byEmail/"

let channelUrl = basicUrl + "channel/"



//notifications

let Notif_user_data_did_change =  Notification.Name ("notifUserDataChanged")
let channels_did_load =  Notification.Name ("channelsLoaded")
let channel_selected =  Notification.Name ("channelselected")














