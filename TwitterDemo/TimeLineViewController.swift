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
        TweeterClient.sharedInstance.getTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
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
        if let screenname = tweet.user?.screenName {
            cell.screenNameLabel.text = "@\(screenname)"
        }
        cell.textLabel?.sizeToFit()
        if tweet.favoriteState! {
            cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
        }else{
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
        TableView.estimatedRowHeight = 44.0
        TableView.rowHeight = UITableViewAutomaticDimension
        
        //Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 223/255, blue: 244/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}
extension TimeLineViewController:TweetCellDelegate{
    
    func favoriteButtonClicked(cell: TweetCell) {
        if cell.favoriteState! {
            TweeterClient.sharedInstance.destroyFavorite(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_on").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
                //                self.TableView.reloadRows(at: [self.TableView.indexPath(for: cell)!], with: UITableViewRowAnimation.none)
                self.TableView.reloadData()
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.createFavorite(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                cell.favoriteButton.setImage(#imageLiteral(resourceName: "like_off").withRenderingMode(.alwaysOriginal), for: cell.favoriteButton.state)
                //                self.TableView.reloadRows(at: [self.TableView.indexPath(for: cell)!], with: UITableViewRowAnimation.none)
                self.TableView.reloadData()
                
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
    func retweetButtonClicked(cell: TweetCell) {
        if cell.retweetState! == false {
            TweeterClient.sharedInstance.retweet(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!].retweetState = true
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: cell.retweetButton.state)
                //                self.TableView.reloadRows(at: [self.TableView.indexPath(for: cell)!], with: UITableViewRowAnimation.none)

                self.TableView.reloadData()
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.unretweet(id: cell.id!, success: {(tweet: Tweet) in
                self.tweets[(self.TableView.indexPath(for: cell)?.row)!].retweetState = false
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: cell.retweetButton.state)
                //                self.TableView.reload
                
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
        }
    }
    func refreshControlAction(refreshController: UIRefreshControl) {
        TweeterClient.sharedInstance.getTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.refreshController.endRefreshing()
            self.TableView.reloadData()
        }, failure: { (error: NSError) in
            self.refreshController.endRefreshing()
            print(error.localizedDescription)
        })

    }
    override func viewWillAppear(_ animated: Bool) {
//        TweeterClient.sharedInstance.getTimeline(success: { (tweets: [Tweet]) in
//            self.tweets = tweets
//            self.TableView.reloadData()
//        }, failure: { (error: NSError) in
//            print(error.localizedDescription)
//        })
    }
}
