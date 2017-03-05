//
//  TimeLineViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/4/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import AFNetworking
import BDBOAuth1Manager

class TimeLineViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        TweeterClient.sharedInstance.logout()
    }
    @IBOutlet weak var TableView: UITableView!
    

    var tweets = [Tweet]()
    var selectedRow = 0
    // Initialize a UIRefreshControl
    let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        // Do any additional setup after loading the view.
        print("TimeLineViewController did load")
        TweeterClient.sharedInstance.getTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets{
                print(tweet.text!)
            }
            self.TableView.reloadData()
        }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
        //Add refresh database
        refreshController.addTarget(self, action: #selector(refreshControlAction(refreshController:)), for: UIControlEvents.valueChanged)
        TableView.insertSubview(refreshController, at: 0)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TimeLineViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        if let user = tweet.user{
            cell.nameLabel.text = user.name
            cell.avatarImage.setImageWith(user.profileUrl)
        }

        cell.statusLabel.text = tweet.text
        cell.favoriteState = tweet.favoriteState
        cell.retweetState = tweet.retweetState
        cell.timestampLabel.text = tweet.timestamp
        
        if tweet.favoriteState! {
            print("favorited")
            print(cell.favoriteButton.state)
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
        }else{
            print("unfavorite")
            print(cell.favoriteButton.state)
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)}
        
        if tweet.retweetState! {
            cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: .normal)}
        cell.id = tweet.tweetID
        cell.delegate = self
        return cell
    }
    func  initView() {
        TableView.delegate = self
        TableView.dataSource = self
    }
}
extension TimeLineViewController:TweetCellDelegate{
    
    func favoriteButtonClicked(cell: TweetCell) {
        print("\(cell.nameLabel)   \(cell.favoriteState)")
        if cell.favoriteState! {
            TweeterClient.sharedInstance.destroyFavorite(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
                self.TableView.reloadData()
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.createFavorite(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
                self.TableView.reloadData()
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
}
extension TimeLineViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetail" {
            selectedRow = (TableView.indexPathForSelectedRow?.row)!
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.tweet = tweets[selectedRow]
            print("tweet: \(selectedRow)")
            print(tweets[selectedRow].user)
        }
//        } else if segue.identifier == "newTweet" {
//            let destinationVC = segue.destination as? NewTweetViewController
//            if let destinationVC = destinationVC {
//                destinationVC.vcDelegate = self
//            }
//        }
    }
    func refreshControlAction(refreshController: UIRefreshControl) {
        TweeterClient.sharedInstance.getTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets{
                print(tweet.text!)
            }
            self.refreshController.endRefreshing()
            self.TableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })

    }
}
