//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/3/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var name: String?
    var text: String?
    var timestamp: Date?
    var retweetCount = 0
    var favoritesCount = 0
    var avatarUrl: URL?
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
        
        let timestampString = (tweet["timestamp"] as? String)

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
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
