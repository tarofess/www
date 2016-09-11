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
    var nounArray = Array<Word>()
    var verbArray = Array<Word>()
    var adjectiveArray = Array<Word>()
    var originalArray = Array<Word>()
    
    private override init() {}
    
    func getWordFromDB() {
        let realm = try! Realm()
        nounArray = realm.objects(Word).filter("speech = '名詞'").map{$0}
        verbArray = realm.objects(Word).filter("speech = '動詞'").map{$0}
        adjectiveArray = realm.objects(Word).filter("speech = '形容詞'").map{$0}
        originalArray = realm.objects(Word).filter("speech = 'オリジナル'").map{$0}
    }

}
