//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 2/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let GuestMomentCollectionCellReuseIden = "GuestMomentCollectionCell"
fileprivate let CheifSpecialCollectionCellReuseIden = "CheifSpecialCollectionCell"

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!{
        didSet{
            self.headerOriginHeight = UIScreen.main.bounds.size.height
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.contentInset = UIEdgeInsets(top: headerOriginHeight, left: 0, bottom: 0, right: 0)
            self.tableView.contentOffset.y = -self.tableView.contentInset.top
            self.tableView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!

    //header constraint
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    var headerOriginHeight: CGFloat = 0

    @IBOutlet weak var navigationBarView: UIView!{
        didSet{
            self.navigationBarView.alpha = 0
        }
    }
    
    @IBOutlet weak var navigationItemCustom: UINavigationItem!{
        didSet{
            self.navigationItemCustom.title = "BISTRO"
        }
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!{
        didSet{
            self.navigationBar.barTintColor = UIColor.white
            self.navigationBar.titleTextAttributes = [NSFontAttributeName: Style.navigationBar.fontAttribute]
        }
    }
    
    
    @IBOutlet weak var statusBtn: UIButton!{
        didSet{
            self.statusBtn.layer.cornerRadius = 6.0
            self.statusBtn.clipsToBounds = true
        }
    }
    
    @IBAction func statusBtnTapped(_ sender: UIButton) {
        sender.animateBounceView(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5)
    }
    
    
    
    //guest moment collection view
    @IBOutlet weak var guestMomentCollectionView: UICollectionView!{
        didSet{
            self.guestMomentCollectionView.alwaysBounceHorizontal = true
            self.guestMomentCollectionView.delegate = self
            self.guestMomentCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var guestMomentCollectionViewHeightConstraint: NSLayoutConstraint!
    
    
    //guest moment dataSource
    var moment: [Moment]?
    
    //status bar control
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateZoomHeader()
        self.guestMomentInit()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.headerHeightConstraint.constant = UIScreen.main.bounds.size.height
        self.headerOriginHeight = self.headerHeightConstraint.constant
        self.tableView.setAndLayoutTableHeaderView(header: self.tableHeaderView)
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    
    private func animateZoomHeader(){
        let transfrom = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.headerView.transform = transfrom
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.headerView.transform = .identity
        }, completion: nil)
    }
    
    private func guestMomentInit(){
        let moment_1 = Moment(momentDict: ["media": "moment-1", "title": "Celebrating Jon's 21st at Bistro"])
        let moment_2 = Moment(momentDict: ["media": "moment-2", "title": "Enjoying green tea ice crema after final"])
        self.moment = [moment_2, moment_1]
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            //adjust heaer when scrollView is global self.tableView
            let adjustOffset = scrollView.contentOffset.y + headerOriginHeight
            if adjustOffset <= 0{
                self.headerViewTopConstraint.constant = 0
                self.headerHeightConstraint.constant = -scrollView.contentOffset.y
            }else{
                self.headerViewTopConstraint.constant = -adjustOffset * 0.6 //create a parallax effect for the header
                var shouldSetStatusBarStyleDefault = false
                let diff = adjustOffset + self.navigationBarView.frame.size.height - UIScreen.main.bounds.size.height;
                if diff > 0{
                    self.navigationBarView.alpha = min(1, diff * 0.04)
                    if self.navigationBarView.alpha > 0.2{
                        self.statusBarStyle = .default
                        shouldSetStatusBarStyleDefault = true
                    }
                }else{
                    self.navigationBarView.alpha = 0
                }
                if !shouldSetStatusBarStyleDefault{
                    self.statusBarStyle = .lightContent
                }
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}



//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moment?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:GuestMomentCollectionCellReuseIden, for: indexPath) as! GuestMomentCollectionViewCell
        cell.moment = self.moment![indexPath.row]
        return cell
    }
    
}


//MARK: - UICollectionViewDelegateFlowLayout
//18 : 14
extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         self.guestMomentCollectionViewHeightConstraint.constant = 180
         return CGSize(width: 180, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}




