//
//  GuestMomentCollectionViewCell.swift
//  Enchant
//
//  Created by Xie kesong on 2/2/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class GuestMomentCollectionViewCell: UICollectionViewCell {
    
    var moment: Moment!{
        didSet{
            if let mediaURL = self.moment.mediaURL{
                self.thumbnailImageView.image = UIImage(named: mediaURL)
            }
            if let title = self.moment.title{
                self.titleLabel.text = title
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!{
        didSet{
            self.thumbnailImageView.layer.cornerRadius = 4.0
            self.thumbnailImageView.clipsToBounds = true
            let overlay = CALayer()
            overlay.frame = thumbnailImageView.bounds
            overlay.backgroundColor = UIColor.black.cgColor
            overlay.opacity = 0
            self.thumbnailImageView.layer.addSublayer(overlay)
        }
    }

}
