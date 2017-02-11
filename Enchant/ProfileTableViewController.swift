//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 1/30/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let cheifSpecialReuseCell = "ChiefSpecialCell"
fileprivate let guestMomentReuseCell = "GuestMomentCell"
fileprivate let GuestMomentCollectionCellReuseIden = "GuestMomentCollectionCell"
fileprivate let CheifSpecialCollectionCellReuseIden = "CheifSpecialCollectionCell"


class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundContainerViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    
    //cheif special collection view
    @IBOutlet weak var cheifSpecialCollectionView: UICollectionView!{
        didSet{
            self.cheifSpecialCollectionView.delegate = self
            self.cheifSpecialCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var chiefSpecialCollectionViewHeightConstraint: NSLayoutConstraint!
    
    //guest moment collection view
    @IBOutlet weak var guestMomentCollectionView: UICollectionView!{
        didSet{
            self.guestMomentCollectionView.delegate = self
            self.guestMomentCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var guestMomentCollectionViewHeightConstraint: NSLayoutConstraint!
    
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
    
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.backgroundImageViewOriginHeight = UIScreen.main.bounds.size.height
        self.backgroundViewHeightConstraint.constant = self.backgroundImageViewOriginHeight
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        self.headerView.frame.size = self.headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.headerView.frame.size.width = UIScreen.main.bounds.size.width
        print( self.headerView.frame.size)
        print(self.tableView.contentSize)
        
        self.tableView.contentSize = CGSize(width: 320, height: 1600)


    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            self.backgroundContainerViewTopSpace.constant = scrollView.contentOffset.y
            self.backgroundViewHeightConstraint.constant =  self.backgroundImageViewOriginHeight - scrollView.contentOffset.y
        }else{
          //  self.overlayView.alpha = min(0.2 + scrollView.contentOffset.y / 2000, 0.4)
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
}



//chief special cell
extension ProfileTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case self.cheifSpecialCollectionView:
            return 6
        case self.guestMomentCollectionView:
            return 3
        default:
            return 0
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:CheifSpecialCollectionCellReuseIden, for: indexPath) as! CheifSpecialCollectionViewCell
        cell.layer.cornerRadius = 6.0
        cell.clipsToBounds = true
        return cell
    }
    
}

extension ProfileTableViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView{
        case self.cheifSpecialCollectionView:
            self.chiefSpecialCollectionViewHeightConstraint.constant = 130
            return CGSize(width: 130, height: 130)
        case self.guestMomentCollectionView:
            self.guestMomentCollectionViewHeightConstraint.constant = 207
            return CGSize(width: 207, height: 207)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}




