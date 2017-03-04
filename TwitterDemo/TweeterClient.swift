//
//  TweeterClient.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/3/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TweeterClient: BDBOAuth1SessionManager {
    
    static let callbackURL = URL(string: "linh://oauth")
    static let consumerKey = "oecUuV0VSomXkKoLlRysUBx9f"
    static let consumerSecret = "YREG9x6YL93WhrSIyxWK9fSzkoV0gYeMZGnFDrbsB1LaBZBXdm"
    static let sharedInstance = TweeterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ())  {
        loginSuccess = success
        loginFailure = failure
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: TweeterClient.callbackURL, scope: nil, success: { (response: BDBOAuth1Credential?) in
            self.loginSuccess = success
            self.loginFailure = failure
            if let response = response{
                print("request token: \(response.token!)")
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                UIApplication.shared.open(authURL!, options: [:], completionHandler: nil)
            }
        }, failure: { (error: Error?) in
            print(error?.localizedDescription ?? "")
            self.loginFailure = error as! ((NSError) -> ())?
        })
    }
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil)
    }
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.UserInfo(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            self.loginSuccess?()

            
        }, failure: { (error:Error?) in
            print(error?.localizedDescription ?? "")
            self.loginFailure?(error as! NSError)
        })
    }
    
    func getTimeline(success: @escaping ([Tweet]) -> (),failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)

            success(tweets)
            
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    
    func UserInfo(success: @escaping (User) -> (),failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            print("my account: \(response)")
            let user = User(user: response as! NSDictionary)
            success(user)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
}
