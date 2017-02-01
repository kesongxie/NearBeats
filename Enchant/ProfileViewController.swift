//
//  ProfileViewController.swift
//  Enchant
//
//  Created by Xie kesong on 1/31/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundContainerViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.delegate = self
            self.scrollView.alwaysBounceVertical = true
        }
    }
    var backgroundImageViewOriginHeight: CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundContainerView.frame.size.width = UIScreen.main.bounds.size.width
        self.backgroundViewHeightConstraint.constant = UIScreen.main.bounds.size.height
        self.backgroundImageViewOriginHeight = self.backgroundViewHeightConstraint.constant
        
        let scaleTransfrom = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.backgroundContainerView.transform = scaleTransfrom
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundContainerView.transform = .identity
        }, completion: nil)

    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            self.backgroundContainerViewTopSpace.constant = scrollView.contentOffset.y
            self.backgroundViewHeightConstraint.constant =  self.backgroundImageViewOriginHeight - scrollView.contentOffset.y
        }else{
            self.backgroundViewHeightConstraint.constant =  self.backgroundImageViewOriginHeight -  scrollView.contentOffset.y
            self.overlayView.alpha = min(0.2 + scrollView.contentOffset.y / 2000, 0.4)
        }
    }

}
