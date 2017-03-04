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
    var profileUrl: URL?
    var tagLine: String?
    
    init(user: NSDictionary) {
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        let profileUrlString = user["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        tagLine =   user["description"] as? String
    }
    
    
    

}
