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
}
