//
//  CreateWordViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class CreateWordViewController: ViewController {
    
    @IBOutlet weak var adjective: UISwitch!
    
    @IBOutlet weak var noun: UISwitch!
    
    @IBOutlet weak var verb: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setSwitchEnable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func judgeSpeechType() -> (Bool, Bool, Bool) {
        let isAdOn = (adjective.on) ? true : false
        let isNounOn = (noun.on) ? true : false
        let isVerbOn = (verb.on) ? true : false
        
        return (isAdOn, isNounOn, isVerbOn)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let resultViewController: ResultViewController = segue.destinationViewController as! ResultViewController
        
        let dbhelper = DatabaseHelper()
        
        if !adjective.on && noun.on && !verb.on {
            var nounData1 = dbhelper.outputWord("名詞")
            var nounData2 = dbhelper.outputWord("名詞")
            resultViewController.newWord = nounData1[Int(arc4random_uniform(UInt32(nounData1.count)))] + nounData2[Int(arc4random_uniform(UInt32(nounData2.count)))]
            
        } else {
        
            let type = self.judgeSpeechType()
            resultViewController.newWord = dbhelper.outputCreatedWord(type.0, isNounOn: type.1, isVerbOn: type.2)
        }
    }
    
    func setSwitchEnable() {
        let nounNum = Word.objectsWhere("speech == '名詞'").count
        if nounNum == 0 {
            self.noun.enabled = false
            self.noun.setOn(false, animated: true)
            
        } else {
            self.noun.enabled = true
            self.noun.setOn(true, animated: true)
        }
        
        let verbNum = Word.objectsWhere("speech == '動詞'").count
        if verbNum == 0 {
            self.verb.enabled = false
            self.verb.setOn(false, animated: true)
            
        } else {
            self.verb.enabled = true
            self.verb.setOn(true, animated: true)
        }
        
        let adjectiveNum = Word.objectsWhere("speech == '形容詞'").count
        if adjectiveNum == 0 {
            self.adjective.enabled = false
            self.adjective.setOn(false, animated: true)
            
        } else {
            self.adjective.enabled = true
            self.adjective.setOn(true, animated: true)
        }
    }
}
