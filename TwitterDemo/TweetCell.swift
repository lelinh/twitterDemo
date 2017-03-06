//
//  TweetsCell.swift
//  TwitterDemo
//
//  Created by Linh Le on 3/4/17.
//  Copyright © 2017 Linh Le. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func favoriteButtonClicked(cell: UITableViewCell)
    @objc optional func retweetButtonClicked(cell: UITableViewCell)
}

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var imageHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var retweetStatusImage: UIImageView!
    @IBOutlet weak var retweetStatusLabel: UILabel!
    
    
    var favoriteState: Bool?
    var retweetState: Bool?
    var id: String?
    
    
    weak var delegate: TweetCellDelegate!
    
    @IBAction func replyClick(_ sender: UIButton) {
    }
    @IBAction func retweetClicked(_ sender: UIButton) {
        delegate.retweetButtonClicked!(cell: self)
    }
    @IBAction func favoriteClicked(_ sender: UIButton) {
        delegate.favoriteButtonClicked!(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        replyButton.setImage(#imageLiteral(resourceName: "reply").withRenderingMode(.alwaysOriginal), for: .normal)
        // Initialization code
        avatarImage.layer.cornerRadius = 7 //set corner for image here
        avatarImage.clipsToBounds = true
        tweetImage.layer.cornerRadius = 7 //set corner for image here
        tweetImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
