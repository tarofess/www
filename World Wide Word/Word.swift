//
//  Word.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class Word: RLMObject {
    var id = 0
    var speech = ""
    var word = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
}
