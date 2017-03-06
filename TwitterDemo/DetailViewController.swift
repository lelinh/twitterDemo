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
        if (tweet?.retweetState)! {
            
            TweeterClient.sharedInstance.unretweet(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: self.retweetButton.state)
                self.updateView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.retweet(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: self.retweetButton.state)
                self.updateView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    @IBAction func likeClicked(_ sender: Any) {
        if (tweet?.favoriteState)! {
            
            TweeterClient.sharedInstance.destroyFavorite(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.likeButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
                
                self.updateView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.createFavorite(id: (tweet?.tweetID)!, success: { (tweet: Tweet) in
                self.tweet = tweet
                self.likeButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
                self.updateView()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension DetailViewController{

    func initView() {
        likeButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
        retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: .normal)
        replyButton.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)

    }
    func updateView(){
        // Initialization code
        avatarImage.layer.cornerRadius = 7 //set corner for image here
        avatarImage.clipsToBounds = true
        TweeterClient.sharedInstance.showTweet(id: (tweet?.tweetID)!, success: {(tweet: Tweet) in
            self.tweet = tweet
            
            self.nameLabel.text = tweet.user?.name
            self.statusLabel.text = tweet.text
            self.avatarImage.setImageWith((tweet.user?.profileUrl)!)
            self.timestampLabel.text = tweet.timestamp
            self.retweetCountLabel.text = "\(tweet.retweetCount) Retweets"
            self.likeCountLabel.text = "\(tweet.favoritesCount) Likes"

            if (tweet.favoriteState)! {
                self.likeButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)
            }else{
                self.likeButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: self.likeButton.state)}
            
            if (tweet.retweetState)! {
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: .normal)}
        }, failure: {(error: NSError) in
            print(error.localizedDescription)
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyFromDetail"{
            let destinationVC = segue.destination as? ReplyViewController
            destinationVC?.originalTweet = tweet
        }
    }
}
