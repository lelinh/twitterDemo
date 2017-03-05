//
//  TimeLineViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/4/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class TimeLineViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!

    
    @IBAction func logoutClicked(_ sender: UIBarButtonItem) {
        TweeterClient.sharedInstance.logout()
    }
    @IBOutlet weak var TableView: UITableView!
    

    var tweets = [Tweet]()
    
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        if let user = tweet.user{
            cell.nameLabel.text = user.name ?? ""
            cell.avatarImage.setImageWith(user.profileUrl)
        }

        cell.statusLabel.text = tweet.text ?? ""
        cell.favoriteState = tweet.favoriteState
        cell.retweetState = tweet.retweetState
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
        if segue.identifier == "showDetail" {
            let destinationVC = segue.destination as? DetailViewController
//            let tweet =
//            if let destinationVC = destinationVC {
//                destinationVC.tweetDetail = tweets[]
//                destinationVC.position = selectedIndex
//                destinationVC.vcDelegate = self
            }
//        } else if segue.identifier == "newTweet" {
//            let destinationVC = segue.destination as? NewTweetViewController
//            if let destinationVC = destinationVC {
//                destinationVC.vcDelegate = self
//            }
//        }
    }
}
