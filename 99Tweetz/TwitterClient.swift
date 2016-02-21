//
//  TwitterClient.swift
//  99Tweetz
//
//  Created by Laub on 2/20/16.
//  Copyright © 2016 Aaron Laub. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "AYXrgWyyPk33CXhlpYxHElxw1", consumerSecret: "B2I7PIwGEQFjUqAeezQ2FOYBoVH8hzqGCO9PzC7fCbl3pgW1ub")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    /* func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    } */
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        
         GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
        
                success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    } 
    
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetsWithArray((response as? [NSDictionary])!)
            
            completion(tweets: tweet, error: nil)

            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweets: nil, error: error)
        }
        
        
        /* GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //   print("user_timeline: \(response)")
            let tweet = Tweet.tweetsWithArray((response as? [NSDictionary])!)
            
            completion(tweets: tweet, error: nil)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error: \(error)")
                completion(tweets: nil, error: error)
            }) */
    }
    



    func favoriteWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary((response as! NSDictionary))
            
            print("This is the retweetCount: \(tweet.retweet_count)")
            print("This is the favCount: \(tweet.favorites_count)")
            
            
            completion(tweet: tweet, error: nil)
            }) { (operation:NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    }
        
        
        
      /* POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary((response as! NSDictionary))
            
            print("This is the retweetCount: \(tweet.retweet_count)")
            print("This is the favCount: \(tweet.favorites_count)")
            

            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        } */
    
    
    func retweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        
        POST("1.1/statuses/retweet/\(params!["id"] as? Int).json", parameters: params, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet.tweetAsDictionary((response as! NSDictionary))
            
            print("This is the retweetCount: \(tweet.retweet_count)")
            print("This is the favCount: \(tweet.favorites_count)")
            
            //  print(tweet)
            
            completion(tweet: tweet, error: nil)
            

            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)

        }
        
    }
       
       /* POST("1.1/statuses/retweet/\(params!["id"] as? Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary((response as! NSDictionary))
            
            print("This is the retweetCount: \(tweet.retweet_count)")
            print("This is the favCount: \(tweet.favorites_count)")
            
            //  print(tweet)
            
            completion(tweet: tweet, error: nil)
            
            }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("ERROR: \(error)")
                completion(tweet: nil, error: error)
        }
    } */


    
    /*func retweetWithCompletion(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params!, success: { (operation: NSURLSessionDataTask!, response: AnyObject!) -> Void in
            print("Successfully retweeted")
            print(response)
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            // let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: NSURLSessionDataTask!, error: NSError!) -> Void in
                print("error: \(error)");
                completion(tweet: nil, error: error)
        }
    }
    
    func favoriteWithCompletion(state: Bool, params: NSDictionary?, completion: (error: NSError?) -> ()) {
        let endpoint = (state) ? "1.1/favorites/create.json" : "1.1/favorites/destroy.json"
        POST(endpoint, parameters: AnyObject?, success: { (operation: NSURLSessionDataTask!, response: AnyObject!) -> Void in
            print(response)
            completion(error: nil)
            }) { (operation: NSURLSessionDataTask!, error: NSError!) -> Void in
                completion(error: error)
        }
    } */
    

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    
    }
        
    func handleOpenUrl(url: NSURL) {
            let requestToken = BDBOAuth1Credential(queryString: url.query)
            fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                    }, failure: { (error: NSError) -> () in
                        self.loginFailure?(error)
                })
                }) { (error: NSError!) -> Void in
                    print("error: \(error.localizedDescription)")
                    self.loginFailure?(error)
            }
        }

}

