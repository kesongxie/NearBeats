//
//  FeedTableViewCell.swift
//  Enchant
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var avatorBtn: UIButton!{
        didSet{
           self.avatorBtn.becomeCircleView()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    var post: Post!{
        didSet{
            self.captionLabel.text = self.post.caption
            self.playVideo()
            guard let size = self.post.video?.size else{
                return
            }
            self.mediaHeightConstraint.constant = size.height * self.frame.size.width / size.width
        }
    }
    
    //player item
    @IBOutlet weak var mediaPlayerView: PlayerView!{
        didSet{
            self.mediaPlayerView.layer.cornerRadius = 4.0
        }
    }
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerItemContext: UnsafeMutableRawPointer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func playVideo(){
        if let fileURL = self.post.video?.videoURL{
            let asset = AVURLAsset(url: fileURL)
            let assetsKey = ["playable"]
            self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
            self.playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: self.playerItemContext)
            self.player = AVPlayer(playerItem: self.playerItem)
            self.mediaPlayerView?.player = self.player;
            self.mediaPlayerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
            NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd(_:)), name: AppNotification.AVPlayerItemDidPlayToEndTimeNotificationName, object: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == self.playerItemContext{
            DispatchQueue.main.async {
                if self.player?.currentItem != nil && self.player?.currentItem?.status == .readyToPlay{
                    self.player?.play()
                }
            }
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    
    func didPlayToEnd(_ notification: Notification){
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    func resetPlayer(){
        self.playerItem?.removeObserver(self, forKeyPath:  #keyPath(AVPlayerItem.status), context: self.playerItemContext)
        self.playerItemContext = nil
        self.player?.pause()
    }

    
    
    
    
}
