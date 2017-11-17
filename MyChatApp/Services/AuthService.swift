//
//  AuthService.swift
//  MyChatApp
//
//  Created by Fahad Rehman on 11/14/17.
//  Copyright © 2017 Codecture. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: Logged_in_key)
        }
        set {
             defaults.set(newValue, forKey: Logged_in_key)
        }
    }
    
    var AuthToken : String {
        get {
            return defaults.value(forKey: Token_id) as! String
        } set {
            defaults.set(newValue, forKey: Token_id)
        }
    }
    
    var UserEmail : String {
        get {
            return defaults.value(forKey: userEmail) as! String
        } set {
            defaults.set(newValue, forKey: userEmail)
        }
    }
    
    func registerUser (email : String , password : String , completion : @escaping completionHandler) {
        let lowercaseemail = email.lowercased()
        let headers: HTTPHeaders = [
        
            "Content-Type": "application/json; charset=utf-8"
        ]
        let parameters: Parameters = [
            "email" : lowercaseemail,
            "password": password
        ]
        
        Alamofire.request(registerUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.debugDescription)
                
            }
        }
    }
    
    func login (email : String , password : String , completion : @escaping completionHandler) {
        let lowercaseemail = email.lowercased()
        let headers: HTTPHeaders = [
            
            "Content-Type": "application/json; charset=utf-8"
        ]
        let parameters: Parameters = [
            "email" : lowercaseemail,
            "password": password
        ]
        Alamofire.request(loginUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
//                if let JSON = response.result.value as? Dictionary<String,Any> {
//                    if let email = JSON ["user"] as? String {
//                        self.UserEmail = email
//                        print(email)
//                    }
//                    if let token = JSON ["token"] as? String {
//                        self.AuthToken = token
//                    }
//                }
                
                guard let data = response.data else { return }
                let json = JSON (data: data)
                self.UserEmail = json ["user"].stringValue
                self.AuthToken = json ["token"].stringValue
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.debugDescription)
                
            }
        }
    }
    func createUsers(name : String , email : String , avatarName: String, avatarColor: String,  completion : @escaping completionHandler)  {
        let lowercaseemail = email.lowercased()
        let parameters: Parameters = [
            "name" : name,
            "email": lowercaseemail,
            "avatarColor" : avatarColor,
            "avatarName" : avatarName
        ]
       let auth = "Bearer " + AuthService.instance.AuthToken
        print(auth)
        let headers: HTTPHeaders = [
            "Authorization" : auth,
            "Content-Type": "application/json; charset=utf-8"
            
        ]
        
        Alamofire.request(AddUserUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                
                print(response.result)
                guard let data = response.data else { return }
               self.setUserInfo(data: data)
                
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.debugDescription)
                
            }
        }
 
    }
    
    func FindUserByEmail (completion : @escaping completionHandler) {
        let urlByEmail = "\(findUserByEmail)\(UserEmail)"
        print(urlByEmail)
        let auth = "Bearer " + AuthService.instance.AuthToken
        let headers: HTTPHeaders = [
            "Authorization" : auth,
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        Alamofire.request(urlByEmail, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                 guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.debugDescription)
            }
        }
    }
    
    func setUserInfo (data : Data) {
        let json = JSON (data: data)
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json ["name"].stringValue
        
        UserDataService.instance.userData(id: id, avName: avName, avColor: color, Email: email, name: name)
    }
}






