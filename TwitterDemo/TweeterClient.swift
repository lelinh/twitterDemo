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
    static let consumerKey = "3VKEJd65ByyvekZDuPls7WVCS"
    static let consumerSecret = "hPtK0YH7JLS50Qdp7sZtj5cBLon6oNbJQWcuJK2JhereAbTQI9"
    static let sharedInstance = TweeterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: consumerKey, consumerSecret: consumerSecret)!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (NSError) -> ())  {
        loginSuccess = success
        loginFailure = failure
        
        fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: TweeterClient.callbackURL, scope: nil, success: { (response: BDBOAuth1Credential?) in
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
        print(url)
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            print("access token = \(accessToken!.token)")
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
    func updateStatus(status: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        post("1.1/statuses/update.json", parameters: ["status":status], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            print("liked: \(response)")
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    func createFavorite(id: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id":id], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    
    func destroyFavorite(id: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id":id], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    func retweet(id: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        post("1.1/statuses/retweet/\(id).json", parameters: ["id":id], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            print(id)
            failure(error as! NSError)
        })
    }
    func unretweet(id: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: ["id":id], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    func showTweet(id: String, success: @escaping (Tweet) -> (),failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/show.json", parameters: ["id":id], progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let tweet = Tweet(tweet: response as! NSDictionary)
            success(tweet)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            failure(error as! NSError)
        })
    }
    func UserInfo(success: @escaping (User) -> (),failure: @escaping (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            print("user account: \(response)")
            let user = User(user: response as! NSDictionary)
            success(user)
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            print(error?.localizedDescription)
            failure(error as! NSError)
        })
    }

}
