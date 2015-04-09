//
//  Word.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation

class Word: RLMObject {
    dynamic var id = 0
    dynamic var speech = ""
    dynamic var word = ""
//    dynamic var nounNum = 0
//    dynamic var verbNum = 0
//    dynamic var adjectiveNum = 0
//    dynamic var newWordNum = 0
    
    override class func primaryKey() -> String {
        return "id"
    }
}
