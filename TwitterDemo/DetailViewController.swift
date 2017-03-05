//
//  DetailViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/5/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {
    
    
    var tweet: Tweet?
    
    
    @IBOutlet weak var avatarImage: UIImageView!

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    @IBAction func replyClicked(_ sender: Any) {
    }
    @IBAction func retweetClicked(_ sender: Any) {
    }
    @IBAction func likeClicked(_ sender: Any) {
        if (tweet?.favoriteState)! {
            
            TweeterClient.sharedInstance.destroyFavorite(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.likeButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
                
                self.initView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.createFavorite(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.likeButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
                self.initView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension DetailViewController{

    func initView() {
        nameLabel.text = tweet?.user?.name
        statusLabel.text = tweet?.text
        avatarImage.setImageWith((tweet?.user?.profileUrl)!)
        timestampLabel.text = tweet?.timestamp
        if let retweetcount = tweet?.retweetCount {
            retweetCountLabel.text = "\(retweetcount) Retweets"
        }
        if let favoritecount = tweet?.favoritesCount {
            likeCountLabel.text = "\(favoritecount) Likes"
        }
        if (tweet?.favoriteState)! {
            likeButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: likeButton.state)
        }else{
            likeButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: likeButton.state)}
        
        if (tweet?.retweetState)! {
            retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: .normal)}
        replyButton.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)
    }
}
