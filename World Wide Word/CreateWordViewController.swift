//
//  CreateWordViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CreateWordViewController: UIViewController, GADBannerViewDelegate {
    
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
    
    private func setAd() {
        bannerView.load(GADRequest())
    }
    
    @IBAction func tappedCreateButton(_ sender: Any) {
        if (!(!adjective.isOn && !noun.isOn && !verb.isOn)) {
            self.performSegue(withIdentifier: "RunResultViewController", sender: self)
        }
    }
    
    private func createOriginalWord() -> String! {
        let adjectiveText: String = adjective.isOn ? WordManager.sharedManager.adjectiveArray[Int.random(in: 0 ..< WordManager.sharedManager.adjectiveArray.count)].word : ""
        let nounText: String = noun.isOn ? WordManager.sharedManager.nounArray[Int.random(in: 0 ..< WordManager.sharedManager.nounArray.count)].word : ""
        let verbText: String = verb.isOn ? WordManager.sharedManager.verbArray[Int.random(in: 0 ..< WordManager.sharedManager.verbArray.count)].word : ""
        
        return adjectiveText + nounText + verbText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultViewController: ResultViewController = segue.destination as! ResultViewController
        
        if !adjective.isOn && noun.isOn && !verb.isOn {
            if let nounArray = WordManager.sharedManager.nounArray {
                let noun1 = nounArray[Int.random(in: 0 ..< nounArray.count)]
                let noun2 = nounArray[Int.random(in: 0 ..< nounArray.count)]
                resultViewController.originalWord = noun1.word + noun2.word
            }
        } else {
            resultViewController.originalWord = createOriginalWord()
        }
    }

}
