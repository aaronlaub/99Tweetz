//
//  Tweet.swift
//  99Tweetz
//
//  Created by Laub on 2/20/16.
//  Copyright © 2016 Aaron Laub. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: NSString?
    var username: NSString?
    var screenname: NSString?
    var id: NSNumber?
    var timestamp: NSDate?
    var retweet_count: Int = 0
    var favorites_count: Int = 0
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        text = dictionary["text"] as? String
        //username = /dictionary["name"] as? String
        //screenname = dictionary["screen_name"] as? String
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favorites_count = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    //convinience method that takes array of dictionaries and returns array of tweets
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        
        let tweet = Tweet(dictionary: dict)
        
        return tweet
    }
    

}
