//
//  ImageViewExtension.swift
//  Enchant
//
//  Created by Xie kesong on 1/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

extension UIView{
    func becomeCircleView(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
    func animateBounceView(){
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {
            self.transform = .identity
        }, completion: nil)
    }
}
