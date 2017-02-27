//
//  HttpClient.swift
//  NearBeats
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Parse

class ParseApp{
    
    class func signUp(username: String, password: String, completion: PFBooleanResultBlock?){
        let user = PFUser()
        user.username = username
        user.password = password
        user.signUpInBackground(block: completion)
    }
    
    /** fetch posts
    */
    class func fetchPost(completion completionHandler: @escaping (_ posts: [Post]?, _ error: Error?) -> Void){
        let fetch = PFQuery(className: Post.className)
        fetch.findObjectsInBackground { (objects, error) in
            if let postObjects = objects{
                let posts = postObjects.map({ (object) -> Post in
                    return Post(object: object)
                })
                completionHandler(posts, nil)
            }else{
                completionHandler(nil, error)
            }
        }

    }
}
