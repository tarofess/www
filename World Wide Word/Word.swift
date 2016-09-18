//
//  Word.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var speech: String!
    dynamic var text: String!
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}
