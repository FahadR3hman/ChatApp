//
//  UserDataService.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/14/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var id = "" //other classes can read it but can't change it
    public private(set) var AvatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var email = ""
    public private(set) var Name = ""
    
    func userData(id : String , avName : String , avColor : String , Email : String , name : String) {
        self.id = id
        AvatarName = avName
        avatarColor = avColor
        email = Email
        Name = name
    }
    
    func updateAvatarName (avatarName : String) {
        self.AvatarName = avatarName
        print(avatarName)
    }
    func returnUIColor(components: String) -> UIColor {
        // "[1,1,1,1]" RGB
        
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[],") // to ignore these values
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor }
        guard let gUnwrapped = g else { return defaultColor }
        guard let bUnwrapped = b else { return defaultColor }
        guard let aUnwrapped = a else { return defaultColor }
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        
        return newUIColor
        
       
    }
    
    func logOutuser () {
        id = ""
        AvatarName = ""
        avatarColor = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.UserEmail = ""
        AuthService.instance.AuthToken = ""
        Name = ""
        email = ""
        MessagesService.instance.ClearChannels()
        MessagesService.instance.removeMessages()
    }
    
}




