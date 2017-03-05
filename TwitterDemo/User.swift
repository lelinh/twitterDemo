//
//  User.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/3/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL!
    var tagLine: String?
    var dictionary: NSDictionary?
    
    static let didLogoutNotification = "UserDidLogout"

    
    init(user: NSDictionary) {
        self.dictionary = user
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        let profileUrlString = user["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString )!
        }
        tagLine =   user["description"] as? String
    }
    
    
    //Save cridential for current user
    static var _currentUser: User?
    static var authorizeStatus: Bool?
    class var currentUser: User?{
        get{
            if _currentUser == nil{
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "CurrentUser") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as! NSDictionary
                    _currentUser = User(user: dictionary)
                }
                
            }
            return _currentUser
        }
        set(user){
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "CurrentUser")
            }else{
                defaults.set(nil, forKey: "CurrentUser")
            }
            defaults.synchronize()
        }
    }
    
    
    

}
