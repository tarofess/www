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
        let adjectiveText: String = adjective.isOn ? WordManager.sharedManager.adjectiveArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.adjectiveArray.count - 1)))].text : ""
        let nounText: String = noun.isOn ? WordManager.sharedManager.nounArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.nounArray.count - 1)))].text : ""
        let verbText: String = verb.isOn ? WordManager.sharedManager.verbArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.verbArray.count - 1)))].text : ""
        
        return adjectiveText + nounText + verbText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController: ResultViewController = segue.destination as! ResultViewController
        
        if !adjective.isOn && noun.isOn && !verb.isOn {
            let nounArray = WordManager.sharedManager.nounArray
            let noun1 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            let noun2 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            resultViewController.originalWord = noun1.text + noun2.text
        } else {
            resultViewController.originalWord = createOriginalWord()
        }
    }

}
