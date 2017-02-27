//
//  MessageTableViewCell.swift
//  NearBeats
//
//  Created by Xie kesong on 2/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    var message: Message!{
        didSet{
            self.messageLabel.text = message.text
            

        }
    }
    @IBOutlet weak var userProfileImageView: UIImageView!{
        didSet{
            self.userProfileImageView.layer.borderWidth = 1.0
            self.userProfileImageView.layer.borderColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1).cgColor
            self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.frame.size.width / 2
            self.userProfileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageLabelWrapper: UIView!{
        didSet{
            self.messageLabelWrapper.layer.cornerRadius = 6.0
            self.messageLabelWrapper.layer.masksToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
