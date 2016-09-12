//
//  ShopViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ShopViewController: ViewController {
    
    @IBOutlet weak var nounSwitch: UISwitch!
    @IBOutlet weak var verbSwitch: UISwitch!
    @IBOutlet weak var adjectiveSwitch: UISwitch!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var productPrice: String!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nounSwitch.addTarget(self, action: #selector(ShopViewController.changeNoun), forControlEvents: UIControlEvents.ValueChanged)
        verbSwitch.addTarget(self, action: #selector(ShopViewController.changeVerb), forControlEvents: UIControlEvents.ValueChanged)
        adjectiveSwitch.addTarget(self, action: #selector(ShopViewController.changeAdje), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setActivityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRectMake(0, 0, 100, 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(indicator)
    }
    
    func changeNoun() {
        if nounSwitch.on {
            verbSwitch.setOn(false, animated: true)
            adjectiveSwitch.setOn(false, animated: true)
        }
    }
    func changeVerb() {
        nounSwitch.setOn(false, animated: true)
        adjectiveSwitch.setOn(false, animated: true)
    }
    func changeAdje() {
        nounSwitch.setOn(false, animated: true)
        verbSwitch.setOn(false, animated: true)
    }
    
    @IBAction func purchase(sender: AnyObject) {
        showConfirmAlert()
    }
    
    func showConfirmAlert() {
        let alertController = UIAlertController(title: "パック欲しい？", message: "パック欲しい？欲しいの？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: {
            (action: UIAlertAction) -> Void in
            self.getDataFromServer()
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getSelectedSpeech() -> String {
        var speech = ""
        
        if nounSwitch.on {
            speech = "名詞"
        } else if verbSwitch.on {
            speech = "動詞"
        } else {
            speech = "形容詞"
        }

        return speech
    }
    
    func showPurchaseAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getDataFromServer() {
        let url = NSURL(string: "http://taro.php.xdomain.jp/word2.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
                "speech": self.getSelectedSpeech(),
                "words": self.makePostWord(self.getSelectedSpeech())
            ]
        
        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(param, options: [])
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                let result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                
                print(result)
                
                let fullWord = result as String
                let words = fullWord.characters.split { $0 == "," }.map { String($0) }
                
                
                if words.count < 30 {
                    self.showPurchaseAlert("エラー", message: "現在ゲットだぜできる分の\(self.getSelectedSpeech)パックがありません")
                    self.indicator.stopAnimating()
                } else {
//                    let realm = try! Realm()
//                    try! realm.write {
//                        for word in words {
//                            realm.add(word)
//                        }
//                    }
                    self.indicator.stopAnimating()
                }
                
            } else {
                self.showPurchaseAlert("エラー", message: "なぜかは分かりませんが\(self.getSelectedSpeech())パックをゲットだぜできませんでした。")
                dispatch_async(dispatch_get_main_queue(), {
                    self.indicator.stopAnimating()
                })
            }
        })
        task.resume()
        
        self.indicator.startAnimating()
    }
    
    func makePostWord(speech: String) -> Array<String> {
        var wordArray: [String] = []
        
        let realm = try! Realm()
        let words = realm.objects(Word).filter("speech = %@", speech).map{$0}
        
        for word in words {
            wordArray.append(word.text)
        }
        
        return wordArray
    }
    
}
