//
//  Global.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit
struct App{
    static let mainStoryboadName = "Main"
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)
    
    struct Style{
        struct navigationController{
            static let titleFont = UIFont(name: "Avenir-Heavy", size: 17.0)!
            static let barTintColor = UIColor.black
            static let titleTextAttribute = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: titleFont]
        }
    }
}

