//
//  CoreNaivigationController.swift
//  Enchant
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class CoreNaivigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = App.Style.navigationController.barTintColor
        self.navigationBar.titleTextAttributes = App.Style.navigationController.titleTextAttribute
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
