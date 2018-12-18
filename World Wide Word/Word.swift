//
//  Word.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object, Codable {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var speech = ""
    @objc dynamic var text = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
}
