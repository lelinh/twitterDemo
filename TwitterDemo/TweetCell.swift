//
//  TweetsCell.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/4/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    
    
    @IBAction func replyClick(_ sender: UIButton) {
    }
    @IBAction func retweetClicked(_ sender: UIButton) {
    }
    @IBAction func favoriteClicked(_ sender: UIButton) {
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImage.layer.cornerRadius = 7 //set corner for image here
        avatarImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
