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
        struct navigationBar{
            static let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
            static let barTintColor = UIColor.white
//            static let titleTextAttribute = [NSFontAttributeName: titleFont]
            static let titleTextAttribute = [String: Any]()

        }
    }
    
    struct NotificationName{
        static let AppWillEnterForeground = Notification.Name("AppWillEnterForegroundNotification")
        static let AVPlayerItemDidPlayToEnd = Notification.Name("AVPlayerItemDidPlayToEndTimeNotification")
    }
    
    
    
    
}

