//
//  ReplyViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/5/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var remainCountLabel: UILabel!
    @IBOutlet weak var originalUserLabel: UILabel!

    var originalTweet: Tweet!
    var originalUser = ""
    var status = ""
    
    
    @IBAction func replyClicked(_ sender: Any) {
        if composeTextView.text.characters.count>0 {

            if let screenName = originalTweet.user?.screenName {
                originalUser = "@\(screenName) "
            }
            if let temp = composeTextView.text{
                status = originalUser + temp
            }
            TweeterClient.sharedInstance.replyTweet(status: status, id: originalTweet.tweetID!, user: originalUser,success: {(tweet: Tweet) in
                print("reply is successful")
            },failure: {(error: NSError) in
                print(error.localizedDescription)
            })
            _ = navigationController?.popViewController(animated: true)
        }else{
            print("reply fail")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
        originalUserLabel.text = "@"+(originalTweet.user?.screenName)!
        avatarImage.setImageWith((User.currentUser?.profileUrl)!)
        nameLabel.text = User.currentUser?.name
        remainCountLabel.text = "140"
        // Initialization code
        avatarImage.layer.cornerRadius = 7 //set corner for image here
        avatarImage.clipsToBounds = true
        originalUserLabel.layer.cornerRadius = 7
        originalUserLabel.clipsToBounds = true
        originalUserLabel.sizeToFit()
        composeTextView.becomeFirstResponder()
        composeTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ReplyViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        let count = (text?.characters.count)! + (originalTweet.user?.screenName.characters.count)! + 1
        remainCountLabel.text = "\(140 - count)"
        if count>140 {
            textView.deleteBackward()
        }
    }
}
