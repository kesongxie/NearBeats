//
//  Moment.swift
//  Enchant
//
//  Created by Xie kesong on 2/11/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

fileprivate let MediaURLKey = "media"
fileprivate let TitleLKey = "title"


class Moment{
    var momentDict: [String: Any]?
    var mediaURL: String?{
        return self.momentDict?[MediaURLKey] as? String
    }
    var title: String?{
        return self.momentDict?[TitleLKey] as? String
    }
    init(momentDict: [String: Any]) {
        self.momentDict = momentDict
    }
}
