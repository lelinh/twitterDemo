//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/3/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import NSDate_TimeAgo

class Tweet: NSObject {

    var text: String?
    var timestamp: String?
    var retweetCount = 0
    var retweetCountString = ""
    var favoritesCount = 0
    var favoritesCountString = ""
    var media: NSDictionary?
    var user: User?
    var favoriteState: Bool?
    var retweetState:Bool?
    var tweetID: String?
    var currentRetweetUser: NSDictionary?
    
    init(tweet: NSDictionary) {
        
        text = tweet["text"] as? String
        retweetCount = (tweet["retweet_count"] as? Int) ?? 0
        favoritesCount = (tweet["favorite_count"] as? Int) ?? 0
        user = User(user: (tweet["user"] as? NSDictionary)!)
        favoriteState  = tweet["favorited"] as? Bool
        retweetState = tweet["retweeted"] as? Bool
        tweetID = tweet["id_str"] as? String
        currentRetweetUser = (tweet["include_my_retweet"] as? NSDictionary?)!
        media = ((tweet["entities"] as? NSDictionary)?["media"] as? [NSDictionary]?)??[0]
        print("debug: \(tweet["entities"] as? NSDictionary)")
        print("debug: \(tweet)")
        
        let timestampString = (tweet["created_at"] as? String)

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
            let time = formatter.date(from: timestampString)
            formatter.dateFormat = "MMM d, h:mm a"
            timestamp = formatter.string(from:time! as Date)
            timestamp = (time as? NSDate)?.timeAgo()
        }
        if retweetCount>1000000 {
            let temp = (Double(retweetCount)/1000000)
            retweetCountString = String(format: "%.2fM", temp)
        }else if retweetCount>1000 {
            let temp = (Double(retweetCount)/1000)
            retweetCountString = String(format: "%.2fK", temp)
        }else{
            retweetCountString = String(format: "%d",retweetCount)
        }
        
        if favoritesCount>1000000 {
            let temp = (Double(favoritesCount)/1000000)
            favoritesCountString = String(format: "%.2fM", temp)
        }else if favoritesCount>1000 {
            let temp = (Double(favoritesCount)/1000)
            favoritesCountString = String(format: "%.2fK", temp)
        }else{
            favoritesCountString = String(format: "%d",favoritesCount)
        }
    }
    
    class func tweetWithArray(dictionaries : [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(tweet: dictionary)
            
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
