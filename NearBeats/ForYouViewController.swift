//
//  MoviesViewController.swift
//  NearBeats
//
//  Created by Xie kesong on 1/10/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "ForYouCell"


fileprivate struct CollectionViewUI{
    static let UIEdgeSpace: CGFloat = 20.0
    static let MinmumLineSpace: CGFloat = 26.0
    static let MinmumInteritemSpace: CGFloat = 20.0
    static let cellCornerRadius: CGFloat = 4.0
}

class ForYouViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.alwaysBounceVertical = true
        }
    }
    
    var users: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.clipsToBounds = true
        let user1 = User(name: "Art Club", profileURLString: "art")
        let user2 = User(name: "Baseball Club", profileURLString: "baseball")
        let user3 = User(name: "Fencing Club", profileURLString: "fencing")
        let user4 = User(name: "Musician Club", profileURLString: "musicianClub")
        let user5 = User(name: "Tennis Club", profileURLString: "tennis")
        let user6 = User(name: "Volleyball Club", profileURLString: "volleyball")

        users = [user1, user2, user3, user4, user5, user6]
        self.collectionView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ForYouViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIden, for: indexPath) as! ForYouCollectionViewCell
        cell.user = self.users![indexPath.row]
        cell.wrapperView.layer.cornerRadius = cell.frame.size.width / 2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ForYouCollectionViewCell
        cell.selectedAccessoryView.isHidden = !cell.selectedAccessoryView.isHidden
        let transform = !cell.selectedAccessoryView.isHidden ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            cell.wrapperView.transform = transform
        }, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ForYouViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let posterLength = (self.view.frame.size.width - 2 * CollectionViewUI.UIEdgeSpace - CollectionViewUI.MinmumInteritemSpace) / 2 ;
        return CGSize(width: posterLength, height: posterLength * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CollectionViewUI.MinmumLineSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake( CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace,  CollectionViewUI.UIEdgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  CollectionViewUI.MinmumInteritemSpace
    }
}

