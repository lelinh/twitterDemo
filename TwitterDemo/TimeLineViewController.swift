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
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        TableView.delegate = self
        TableView.dataSource = self
        //Instantiate ComposeViewController
        let composeViewController = storyboard?.instantiateViewController(withIdentifier: "ComposeViewController") as! ComposeViewController
        composeViewController.delegate = self
        
        TableView.estimatedRowHeight = 44.0
        TableView.rowHeight = UITableViewAutomaticDimension
        
        //Navigation bar color
        navigationController?.navigationBar.barTintColor = UIColor(red: 66/255, green: 223/255, blue: 244/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        //Get timeline
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
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: TableView.contentSize.height, width: TableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        TableView.addSubview(loadingMoreView!)
        
        var insets = TableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        TableView.contentInset = insets
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
        cell.retweetCountLabel.text = tweet.retweetCountString
        cell.favoriteCountLabel.text = tweet.favoritesCountString
        
        if let temp = tweet.currentRetweetUser{
            print(temp)
        }else{
            print("include_my_retweet is nil")
        }
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
                let id = self.tweets[(self.TableView.indexPath(for: cell)?.row)!].tweetID
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_on").withRenderingMode(.alwaysOriginal), for: cell.retweetButton.state)
                //                self.TableView.reloadRows(at: [self.TableView.indexPath(for: cell)!], with: UITableViewRowAnimation.none)
                TweeterClient.sharedInstance.showTweet(id: (id)!, success: {(tweet: Tweet) in
                    self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                    self.TableView.reloadData()
                }, failure: {(error: NSError) in
                    print(error.localizedDescription)
                })
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }else{
            TweeterClient.sharedInstance.unretweet(id: cell.id!, success: {(tweet: Tweet) in
                let id = self.tweets[(self.TableView.indexPath(for: cell)?.row)!].tweetID
                cell.retweetButton.setImage(#imageLiteral(resourceName: "retweet_off").withRenderingMode(.alwaysOriginal), for: cell.retweetButton.state)
                TweeterClient.sharedInstance.showTweet(id: (id)!, success: {(tweet: Tweet) in
                    self.tweets[(self.TableView.indexPath(for: cell)?.row)!] = tweet
                    self.TableView.reloadData()
                }, failure: {(error: NSError) in
                    print(error.localizedDescription)
                })
                
            }, failure: {(error: NSError) in
                print(error.localizedDescription)
            })
        }
    }
}
extension TimeLineViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = TableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - TableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && TableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: TableView.contentSize.height, width: TableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    func loadMoreData() {
        TweeterClient.sharedInstance.getTimelineBeforeID(id: (tweets.last?.tweetID ?? "0")!, success: { (tweets: [Tweet]) in
            var copyTweets = tweets
            copyTweets.remove(at: 0)
            self.tweets = self.tweets + copyTweets
            
            // Update flag
            self.isMoreDataLoading = false
            //remove top tweets
            if self.tweets.count>100{
                for i in 1...20{
                    self.tweets.remove(at: i)
                }
            }
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
            
            self.TableView.reloadData()
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
}
extension TimeLineViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetDetail" {
            selectedRow = (TableView.indexPathForSelectedRow?.row)!
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.tweet = tweets[selectedRow]
        }else if segue.identifier == "replyFromTimeline"{
            let destinationVC = segue.destination as? ReplyViewController
            destinationVC?.originalTweet = tweets[selectedRow]
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
extension TimeLineViewController: ComposeViewControllerDelegate{
    func sentTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        print(tweets[0])
        TableView.reloadData()
    }
}
