//
//  Message.swift
//  NearBeats
//
//  Created by Xie kesong on 2/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import Parse

fileprivate let TextKey = "text"
fileprivate let UserKey = "user"

class Message{
    static let className = "Message"
    init(){
        self.object = PFObject(className: Message.className)
    }
    init(object: PFObject) {
        self.object = object
    }
    
    convenience init(text: String, user: PFUser) {
        self.init()
        self.object?[TextKey] = text
        self.object?[UserKey] = user
    }
    
    var object: PFObject?
    
    var user: PFObject?{
        return self.object?[UserKey] as? PFObject
    }
    var text: String?{
        return self.object?[TextKey] as? String
    }
    func saveInBackground(block: PFBooleanResultBlock?){
        self.object?.saveInBackground(block: block)
    }
    
    class func fetchMessages(completion completionHandler: @escaping (_ messages: [Message]?, _ error: Error?) -> Void){
        let query = PFQuery(className: Message.className)
        query.findObjectsInBackground { (objects, error) in
            if let objects = objects{
                let messages = objects.map({ (object) -> Message in
                    return Message(object: object)
                })
                completionHandler(messages, nil)
            }else{
                completionHandler(nil, error)
            }
        }
    }
    
       
}
