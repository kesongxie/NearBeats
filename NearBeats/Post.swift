//
//  Moment.swift
//  NearBeats
//
//  Created by Xie kesong on 2/11/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Parse

fileprivate let MediaURLKey = "media"
fileprivate let CaptionLKey = "caption"

class Post{
    static let className = "Post"

    var pfObject: PFObject?

    var video: Video?{
        return self.pfObject != nil ? Video(pfObject: self.pfObject!) : nil
    }
    var caption: String?{
        return self.pfObject?[CaptionLKey] as? String
    }
    
    init(object: PFObject) {
        self.pfObject = object
    }
}
