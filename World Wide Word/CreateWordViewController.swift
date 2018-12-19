//
//  CreateWordViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CreateWordViewController: UIViewController {
    
    @IBOutlet weak var adjective: UISwitch!
    @IBOutlet weak var noun: UISwitch!
    @IBOutlet weak var verb: UISwitch!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAd() {
        bannerView.adUnitID = "ca-app-pub-7727323242900759/9765737025"
        bannerView.load(GADRequest())
    }
    
    func createOriginalWord() -> String! {
        let adjectiveText: String = adjective.isOn ? WordManager.sharedManager.adjectiveArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.adjectiveArray.count - 1)))].word : ""
        let nounText: String = noun.isOn ? WordManager.sharedManager.nounArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.nounArray.count - 1)))].word : ""
        let verbText: String = verb.isOn ? WordManager.sharedManager.verbArray[Int(arc4random_uniform(UInt32(WordManager.sharedManager.verbArray.count - 1)))].word : ""
        
        return adjectiveText + nounText + verbText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController: ResultViewController = segue.destination as! ResultViewController
        
        if !adjective.isOn && noun.isOn && !verb.isOn {
            let nounArray = WordManager.sharedManager.nounArray
            let noun1 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            let noun2 = nounArray[Int(arc4random_uniform(UInt32(nounArray.count - 1)))]
            resultViewController.originalWord = noun1.word + noun2.word
        } else {
            resultViewController.originalWord = createOriginalWord()
        }
    }

}
