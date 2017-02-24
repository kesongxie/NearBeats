//
//  MediaPlayer.swift
//  Enchant
//
//  Created by Xie kesong on 2/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import AVFoundation
import UIKit

protocol MediaPlayerDelegate: class{
    func didPlayToEnd(_ notification: Notification)
}


class MediaPlayer{
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    var playerItemContext: UnsafeMutableRawPointer!
    var asset: AVURLAsset!
    var mediaPlayerView: PlayerView!
    var url: URL!
    
    init?(url: URL, owner: MediaPlayerDelegate) {
        self.url = url
        self.asset = AVURLAsset(url: self.url)
        let assetsKey = ["playable"]
        self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetsKey)
     //   self.playerItem.addObserver(owner, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: self.playerItemContext)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.mediaPlayerView?.player = self.player;
        self.mediaPlayerView.playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
//        NotificationCenter.default.addObserver(owner, selector: #selector(owner.didPlayToEnd(_:)), name: AppNotification.AVPlayerItemDidPlayToEndTimeNotificationName, object: nil)

    }


}
