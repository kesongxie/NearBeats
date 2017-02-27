//
//  ForYouCollectionViewCell.swift
//  NearBeats
//
//  Created by Xie kesong on 1/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class ForYouCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatorImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var wrapperView: UIView!{
        didSet{
            self.wrapperView.clipsToBounds = true
        }
    }
    @IBOutlet weak var selectedAccessoryView: UIView!
    var user: User!{
        didSet{
            self.avatorImageView.image = UIImage(named: self.user.profileURLString!)
            self.nameLabel.text = self.user.name
        }
    }
    
    
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}

