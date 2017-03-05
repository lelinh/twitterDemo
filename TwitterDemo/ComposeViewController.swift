//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/5/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit
import AFNetworking

class ComposeViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var remainCountLabel: UILabel!
    
    @IBAction func tweetClicked(_ sender: Any) {
        TweeterClient.sharedInstance.updateStatus(status: composeTextView.text, success: {(tweet: Tweet) in
            print("status is updated")
        },failure: {(error: NSError) in
            print(error.localizedDescription)
        })
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        avatarImage.setImageWith((User.currentUser?.profileUrl)!)
        nameLabel.text = User.currentUser?.name
        remainCountLabel.text = "140"
        
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
