//
//  GuestMomentCollectionViewCell.swift
//  Enchant
//
//  Created by Xie kesong on 2/2/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class GuestMomentCollectionViewCell: UICollectionViewCell {
    
    var post: Post!{
        didSet{
//            if let mediaURL = self.post.mediaURL{
////                self.thumbnailImageView.image = UIImage(named: mediaURL)
//            }
//            if let title = self.post.caption{
//                self.titleLabel.text = title
//            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 45.0
            self.thumbnailImageView.clipsToBounds = true
            self.thumbnailImageView.layer.borderColor = UIColor(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 240 / 255.0).cgColor
            self.thumbnailImageView.layer.borderWidth = 1.0
            
            let overlay = CALayer()
            overlay.frame = thumbnailImageView.bounds
            overlay.backgroundColor = UIColor.black.cgColor
            overlay.opacity = 0
            self.thumbnailImageView.layer.addSublayer(overlay)
        }
    }

}
