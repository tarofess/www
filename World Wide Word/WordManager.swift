//
//  WordManager.swift
//  World Wide Word
//
//  Created by taro on 2016/09/11.
//  Copyright © 2016年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class WordManager: NSObject {
    
    static let sharedManager = WordManager()
    var nounArray = [Word]()
    var verbArray = [Word]()
    var adjectiveArray = [Word]()
    var originalArray = [Word]()
    
    fileprivate override init() {}
    
    func getWordFromDB() {
        let realm = try! Realm()
        nounArray = realm.objects(Word.self).filter("type = 1").map{$0}
        verbArray = realm.objects(Word.self).filter("type = 2").map{$0}
        adjectiveArray = realm.objects(Word.self).filter("type = 3").map{$0}
        originalArray = realm.objects(Word.self).filter("type = 4").map{$0}
    }

}
