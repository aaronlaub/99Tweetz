//
//  TweetCell.swift
//  99Tweetz
//
//  Created by Laub on 2/20/16.
//  Copyright © 2016 Aaron Laub. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var _usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    var tweetID: NSNumber!

    var tweet: Tweet! {
        didSet {

            usernameLabel.text = String(tweet.user!.name!)
            _usernameLabel.text = "@\(tweet.user!.screenname)"
            tweetLabel.text = tweet.text as? String
            retweetLabel.text = "\(String(tweet.retweet_count)) Retweets"

            favoritesLabel.text = "\(String(tweet.favorites_count)) Favorites"
            
            profileImageView.setImageWithURL(tweet.user!.profileUrl!)
            
            timeLabel.text = calculateTimeStamp(tweet.timestamp!.timeIntervalSinceNow)
            
            tweetID = tweet!.id
            
        }
    }

    //All credit for this method goes to David Wayman, slack @dwayman
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    @IBAction func retweetButtonClicked(sender: AnyObject) {
        
        print("Retweet button clicked")
        
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> ()  in
            
            if (self.tweet != nil) {
                
                //self.retweetButton.setImage(UIImage(named: "retweet-action-on-green.png"), forState: UIControlState.Normal)
                
                if self.retweetLabel.text! > "0" {
                    self.retweetLabel.text = String(self.tweet!.retweet_count + 1)
                } else {
                    self.retweetLabel.hidden = false
                    self.retweetLabel.text =
                        String(self.tweet!.retweet_count + 1)
                }
                
            }
            else {
                print("ERROR retweeting: \(error)")
            }
        }
    }
    
    @IBAction func likeButtonClicked(sender: AnyObject) {
        
        print("Like button clicked")
        
        TwitterClient.sharedInstance.favoriteWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (self.tweet != nil) {
                
                //self.favButton.setImage(UIImage(named: "like-action-on-red.png"), forState: UIControlState.Normal)
                
                if self.favoritesLabel.text! > "0" {
                    self.favoritesLabel.text = String(self.tweet!.favorites_count + 1)
                } else {
                    self.favoritesLabel.hidden = false
                    self.favoritesLabel.text = String(self.tweet!.favorites_count + 1)
                }
                
            }
            else {
                print("Did it print the print fav tweet? cause this is the error message and you should not be seeing this.")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        usernameLabel.preferredMaxLayoutWidth = usernameLabel.frame.size.width
        _usernameLabel.preferredMaxLayoutWidth = _usernameLabel.frame.size.width
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        usernameLabel.preferredMaxLayoutWidth = usernameLabel.frame.size.width
        _usernameLabel.preferredMaxLayoutWidth = _usernameLabel.frame.size.width
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
