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
    var favoritesCount = 0

    var user: User?
    var favoriteState: Bool?
    var retweetState:Bool?
    var tweetID: String?
    
    
    init(tweet: NSDictionary) {
        
        text = tweet["text"] as? String
        retweetCount = (tweet["retweet_count"] as? Int) ?? 0
        favoritesCount = (tweet["favorite_count"] as? Int) ?? 0
        user = User(user: (tweet["user"] as? NSDictionary)!)
        favoriteState  = tweet["favorited"] as? Bool
        retweetState = tweet["retweeted"] as? Bool
        tweetID = tweet["id_str"] as? String

        
        let timestampString = (tweet["created_at"] as? String)

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z y"
            let time = formatter.date(from: timestampString)
            formatter.dateFormat = "MMM d, h:mm a"
            timestamp = formatter.string(from:time! as Date)
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
