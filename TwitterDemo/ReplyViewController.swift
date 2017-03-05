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

    
    @IBAction func replyClicked(_ sender: Any) {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
