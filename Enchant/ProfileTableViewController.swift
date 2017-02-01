//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 1/30/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let cheifSpecialReuseCell = "ChiefSpecialCell"

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundContainerViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    
    var backgroundImageViewOriginHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let scaleTransfrom = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.headerView.transform = scaleTransfrom
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.headerView.transform = .identity
        }, completion: nil)

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerView.frame.size = UIScreen.main.bounds.size
        self.backgroundImageViewOriginHeight = self.headerView.frame.size.height
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            self.backgroundContainerViewTopSpace.constant = scrollView.contentOffset.y
            self.headerView.frame.size.height =  self.backgroundImageViewOriginHeight - scrollView.contentOffset.y
        }else{
            self.overlayView.alpha = min(0.2 + scrollView.contentOffset.y / 2000, 0.4)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cheifSpecialReuseCell, for: indexPath) as! CheifSpecialTableViewCell
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        return cell
    }
    
    
    
}


