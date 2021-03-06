//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/5/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import AFNetworking


@objc protocol ComposeViewControllerDelegate{
    @objc optional func sentTweet(tweet: Tweet)
}

class ComposeViewController: UIViewController {

    weak var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var remainCountLabel: UILabel!
    
    @IBAction func tweetClicked(_ sender: Any) {
        if composeTextView.text.characters.count>0 {
            TweeterClient.sharedInstance.updateStatus(status: composeTextView.text, success: {(tweet: Tweet) in
                print("status is updated")
                print(tweet)
                self.delegate?.sentTweet!(tweet: tweet)
            },failure: {(error: NSError) in
                print(error.localizedDescription)
            })
            _ = navigationController?.popViewController(animated: true)
        }else{
            print("tweet fail")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImage.setImageWith((User.currentUser?.profileUrl)!)
        nameLabel.text = User.currentUser?.name
        remainCountLabel.text = "140"
        // Initialization code
        avatarImage.layer.cornerRadius = 7 //set corner for image here
        avatarImage.clipsToBounds = true
        composeTextView.becomeFirstResponder()
        composeTextView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        let count = text?.characters.count
        remainCountLabel.text = "\(140 - count!)"
        if count!>140 {
            textView.deleteBackward()
        }
    }
}
