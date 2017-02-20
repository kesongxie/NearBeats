//
//  Video.swift
//  Enchant
//
//  Created by Xie kesong on 2/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Parse

fileprivate let VideoFileLKey = "media"
fileprivate let WidthLKey = "width"
fileprivate let HeightLKey = "height"


struct Video{
    var videoURL: URL?{
        return  URL(string: self.pfFile?.url ?? "")
    }
    var pfFile: PFFile?
    var size: CGSize!
    init(pfObject: PFObject){
        if let file = pfObject[VideoFileLKey] as? PFFile {
            self.pfFile = file
        }
        if let width = pfObject[WidthLKey] as? CGFloat, let height = pfObject[HeightLKey] as? CGFloat{
            self.size = CGSize(width: width, height: height)
        }
        
    }
}
