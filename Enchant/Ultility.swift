//
//  Ultility.swift
//  Enchant
//
//  Created by Xie kesong on 1/24/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

func createRadomFileName(withExtension ext: String) -> String{
    let filename = UUID().uuidString.appending(ext)
    return NSTemporaryDirectory().appending(filename)
}
