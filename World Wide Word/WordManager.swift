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
    
    private override init() {
        super.init()
        
        nounArray = getWordByType(type: 1)
        verbArray = getWordByType(type: 2)
        adjectiveArray = getWordByType(type: 3)
        originalArray = getWordByType(type: 4)
    }
    
    func getWordByType(type: Int) -> [Word] {
        let realm = try! Realm()
        return realm.objects(Word.self).filter("type = \(type)").map{$0}
    }

    func addWordToDB(type: Int, word: String) {
        let w = Word()
        w.type = type
        w.word = word
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(w)
        }
    }
    
    func removeWordFromDB(word: Word) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(word)
        }
    }
    
    func isExistsSameData(type: Int, word: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "type = %d AND word = %@", type, word)
        let words = realm.objects(Word.self).filter(predicate)
        
        if words.isEmpty {
            return false
        } else {
            return true
        }
    }
    
}
