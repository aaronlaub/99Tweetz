//
//  User.swift
//  99Tweetz
//
//  Created by Laub on 2/20/16.
//  Copyright © 2016 Aaron Laub. All rights reserved.
//

import UIKit
var _currentUser: User?

class User: NSObject {

    var name: NSString?
    var screenname: NSString!
    var profileUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let imageURLString = dictionary["profile_image_url_https"] as? String
        if imageURLString != nil {
            profileUrl = NSURL(string: imageURLString!)!
        }
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"

    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
        
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")

            }
            
            defaults.synchronize()
        }
    }
}
    

