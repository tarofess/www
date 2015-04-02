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
    
    func outputNewWord() -> String {
        return ""
    }
    
    func outputNoun() {
        
    }
    
    func outputAdjective() {
        
    }
    
    func outputVerb() {
        
    }
    
}
