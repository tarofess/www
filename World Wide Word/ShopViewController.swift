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

class ShopViewController: UIViewController {
    
    @IBOutlet weak var nounSwitch: UISwitch!
    @IBOutlet weak var verbSwitch: UISwitch!
    @IBOutlet weak var adjectiveSwitch: UISwitch!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var productPrice: String!
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
        setActivityIndicator()
        
        nounSwitch.addTarget(self, action: #selector(ShopViewController.changeNoun), for: UIControlEvents.valueChanged)
        verbSwitch.addTarget(self, action: #selector(ShopViewController.changeVerb), for: UIControlEvents.valueChanged)
        adjectiveSwitch.addTarget(self, action: #selector(ShopViewController.changeAdje), for: UIControlEvents.valueChanged) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAd() {
        bannerView.load(GADRequest())
    }
    
    func setActivityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(indicator)
    }
    
    @objc func changeNoun() {
        if nounSwitch.isOn {
            verbSwitch.setOn(false, animated: true)
            adjectiveSwitch.setOn(false, animated: true)
        }
    }
    @objc func changeVerb() {
        nounSwitch.setOn(false, animated: true)
        adjectiveSwitch.setOn(false, animated: true)
    }
    @objc func changeAdje() {
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
        request.timeoutInterval = 10.0
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
                "speech": self.getSelectedSpeech(),
                "words": self.makePostWord(self.getSelectedSpeech())
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
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
        }
        task.resume()
        
        self.indicator.startAnimating()
    }
    
    func makePostWord(_ speech: String) -> Array<String> {
        var wordArray: [String] = []
        
//        let realm = try! Realm()
//        let words = realm.objects(Word.self).filter("speech = %@", speech).map{$0}
//
//        for word in words {
//            wordArray.append(word.word)
//        }
        
        return wordArray
    }
    
    func saveWords(jsonResult: [[String: String]]) {
//        let realm = try! Realm()
//        try! realm.write {
//            for (key, value) in jsonResult.flatMap({$0}) {
//                let word = Word()
//                word.type = key
//                word.word = value
//                realm.add(word)
//            }
//        }
    }
    
}
