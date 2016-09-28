//
//  ShopViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ShopViewController: ViewController {
    
    @IBOutlet weak var nounSwitch: UISwitch!
    @IBOutlet weak var verbSwitch: UISwitch!
    @IBOutlet weak var adjectiveSwitch: UISwitch!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var bannerView5: GADBannerView!
    
    var productPrice: String!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nounSwitch.addTarget(self, action: #selector(ShopViewController.changeNoun), for: UIControlEvents.valueChanged)
        verbSwitch.addTarget(self, action: #selector(ShopViewController.changeVerb), for: UIControlEvents.valueChanged)
        adjectiveSwitch.addTarget(self, action: #selector(ShopViewController.changeAdje), for: UIControlEvents.valueChanged)
        
        setActivityIndicator()
        setAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setActivityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(indicator)
    }
    
    func changeNoun() {
        if nounSwitch.isOn {
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
    
    @IBAction func purchase(_ sender: AnyObject) {
        showConfirmAlert()
    }
    
    func showConfirmAlert() {
        let alertController = UIAlertController(title: "パック欲しい？", message: "パック欲しい？欲しいの？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.getDataFromServer()
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getSelectedSpeech() -> String {
        var speech = ""
        
        if nounSwitch.isOn {
            speech = "名詞"
        } else if verbSwitch.isOn {
            speech = "動詞"
        } else {
            speech = "形容詞"
        }

        return speech
    }
    
    func showCompletionAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        self.indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func getDataFromServer() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let url = URL(string: "http://taro.php.xdomain.jp/word2.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
                "speech": self.getSelectedSpeech(),
                "words": self.makePostWord(self.getSelectedSpeech())
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if error == nil {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: String]] {
                        self.saveWords(jsonResult: jsonResult)
                        self.showCompletionAlert("ゲットだぜ！", message: "\(self.getSelectedSpeech())パックをゲットだぜしました")
                    } else {
                        self.showCompletionAlert("エラー", message: "現在ゲットだぜできる分の\(self.getSelectedSpeech())パックがありません")
                    }
                } catch {
                    self.showCompletionAlert("エラー", message: "なぜかは分かりませんが\(self.getSelectedSpeech())パックをゲットだぜできませんでした")
                }
                self.indicator.stopAnimating()
                
            } else {
                self.showCompletionAlert("エラー", message: "なぜかは分かりませんが\(self.getSelectedSpeech())パックをゲットだぜできませんでした")
            }
        }
        task.resume()
        
        self.indicator.startAnimating()
    }
    
    func makePostWord(_ speech: String) -> Array<String> {
        var wordArray: [String] = []
        
        let realm = try! Realm()
        let words = realm.objects(Word.self).filter("speech = %@", speech).map{$0}
        
        for word in words {
            wordArray.append(word.text)
        }
        
        return wordArray
    }
    
    func saveWords(jsonResult: [[String: String]]) {
        let realm = try! Realm()
        try! realm.write {
            for (key, value) in jsonResult.flatMap({$0}) {
                let word = Word()
                word.speech = key
                word.text = value
                realm.add(word)
            }
        }
    }
    
    //Ad
    
    override func setAd() {
        bannerView5.adUnitID = "ca-app-pub-7727323242900759/9765737025"
        bannerView5.rootViewController = self
        bannerView5.load(GADRequest())
        
        let gadRequest:GADRequest = GADRequest()
        gadRequest.testDevices = ["35813d541edaeba54769a1516fc90516"];
    }
    
}
