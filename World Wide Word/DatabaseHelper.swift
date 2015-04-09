//
//  DatabaseHelper.swift
//  
//
//  Created by taro on 2015/04/01.
//
//

import Foundation
import UIKit

class DatabaseHelper {
    var autoincrementId = 0
    
    func inputWordToDatabase(registerWord: String, registerSpeech: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        autoincrementId = ud.integerForKey("incrementKey")
        
        let word = Word()
        word.id = autoincrementId
        word.speech = registerSpeech
        word.word = registerWord
        
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock({ () -> Void in
            realm.addObject(word)
        })
        
        autoincrementId++
        
        ud.setInteger(autoincrementId, forKey: "incrementKey")
    }
    
    func outputWord(speech: String) -> Array<String> {
        var wordData: [String] = []
        let wordArray = Word.objectsWhere("speech CONTAINS %@", speech)
        
        for item in wordArray {
            if let wordStore = item as? Word {
                wordData.append(wordStore.word)
            }
        }
        
        return wordData
    }
    
    func removeWord(speech: String, id: Int) {
        let realm = RLMRealm.defaultRealm()
        realm.transactionWithBlock( { () -> Void in
        realm.deleteObjects(Word.objectsWhere("id == %d AND speech == %@", id, speech))
    })
}


    func outputCreatedWord(isAdOn: Bool, isNounOn: Bool, isVerbOn: Bool) -> String {
        var newWord = ""
        var adData: [String] = []
        var nounData: [String] = []
        var verbData: [String] = []
        
        if isAdOn {
            adData = outputWord("形容詞")
            newWord += adData[Int(arc4random_uniform(UInt32(adData.count)))]
        }
        
        if isNounOn {
            nounData = outputWord("名詞")
            newWord += nounData[Int(arc4random_uniform(UInt32(nounData.count)))]
        }
        
        if isVerbOn {
            verbData = outputWord("動詞")
            newWord += verbData[Int(arc4random_uniform(UInt32(verbData.count)))]
        }
        
        return newWord
    }
}
