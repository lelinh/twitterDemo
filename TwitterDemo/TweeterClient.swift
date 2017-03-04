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
    
    static let sharedInstance = TweeterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "5nQZPxT30BfHdTHrHfp7VI5cH", consumerSecret: "EYxIALQ6uPsR4Zl06X6n6FgK5yKvYi4Qup3iEGru8p9tYGkdju")!
    
    func getTimeline() {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            for tweet in tweets{
                print(tweet.text!)
            }
            
            
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            print(error?.localizedDescription ?? "" )
        })
    }
    
    func getUserInfo() {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (_:URLSessionDataTask, response:Any?) in
            print("my account: \(response)")
        }, failure: { (_:URLSessionDataTask?, error:Error?) in
            print(error?.localizedDescription ?? "")
        })
    }
}
