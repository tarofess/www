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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createOriginalWord() -> String! {
        let adjectiveText = adjective.on ? WordManager.sharedManager.adjectiveArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.adjectiveArray.count - 1)))].text : ""
        let nounText = noun.on ? WordManager.sharedManager.nounArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.nounArray.count - 1)))].text : ""
        let verbText = verb.on ? WordManager.sharedManager.verbArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.verbArray.count - 1)))].text : ""
        
        return adjectiveText + nounText + verbText
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let resultViewController: ResultViewController = segue.destinationViewController as! ResultViewController
        
        if !adjective.on && noun.on && !verb.on {
            let nounArray = WordManager.sharedManager.nounArray
            let noun1 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            let noun2 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            resultViewController.originalWord = noun1.text + noun2.text
        } else {
            resultViewController.originalWord = createOriginalWord()
        }
    }

}
