//
//  HomeViewController.swift
//  Enchant
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let ReuseIden = "PostCell"
fileprivate let PostNibName = "PostTableViewCell"

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            let nib = UINib(nibName: PostNibName, bundle: nil)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(nib, forCellReuseIdentifier: ReuseIden)
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var posts: [Post]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        saveVideo()
        ParseApp.fetchPost { (posts, error) in
            if let posts = posts{
                self.posts = posts
            }
        }
    }

    func saveVideo(){
        let bundle = Bundle.main
        if let path = bundle.path(forResource: "full", ofType: "mp4", inDirectory: "Media"){
            let url = URL(fileURLWithPath: path)
            self.playVideoAfterFinishedRecording(withVideoURL: url)
        }
    }
    
    
    func playVideoAfterFinishedRecording(withVideoURL url: URL){
        let post = PFObject(className: "Post")
        post["caption"] = "Out of the game for 6 months, but back with vengeance. Meet your 2017 AO Men's champion"
        do{
            let data = try Data(contentsOf: url)
            post["media"] = PFFile(data: data, contentType: "video/mp4")
            post["width"] = 640
            post["height"] = 320
            
            post.saveInBackground { (success, error) in
                if success{
                    print("video saved")
                }else{
                    print("failed")
                    if error != nil{
                        print(error!.localizedDescription)
                    }else{
                        print("erorr is nil")
                    }
                }
            }
        }catch let error as NSError{
            print("can't read")
            print(error.localizedDescription)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIden, for: indexPath) as! PostTableViewCell
        cell.post = posts![indexPath.row]
        return cell
    }
}
