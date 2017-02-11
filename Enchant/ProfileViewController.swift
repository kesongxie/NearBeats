//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 2/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "cell"

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!{
        didSet{
            self.headerOriginHeight = UIScreen.main.bounds.size.height
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
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
        }
    }
    
    //status bar control
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let transfrom = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.headerView.transform = transfrom
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.headerView.transform = .identity
        }, completion: nil)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let adjustOffset = scrollView.contentOffset.y + headerOriginHeight
        if adjustOffset <= 0{
            self.headerViewTopConstraint.constant = 0
            self.headerHeightConstraint.constant = -scrollView.contentOffset.y
        }else{
            self.headerViewTopConstraint.constant = -adjustOffset * 0.6 //create a parallax effect for the header
            var shouldSetStatusBarStyleDefault = false
            let diff = adjustOffset + self.navigationBarView.frame.size.height - UIScreen.main.bounds.size.height;
            if diff > 0{
                self.navigationBarView.alpha = min(1, diff * 0.02)
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath)
        return cell
    }
    
    
    
}
