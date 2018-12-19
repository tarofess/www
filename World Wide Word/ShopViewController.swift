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
    
    private var productPrice: String!
    private var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
        setActivityIndicator()
        setSwitchAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setAd() {
        bannerView.load(GADRequest())
    }
    
    private func setActivityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(indicator)
    }
    
    private func setSwitchAction() {
        nounSwitch.addTarget(self, action: #selector(ShopViewController.changeNoun), for: UIControlEvents.valueChanged)
        verbSwitch.addTarget(self, action: #selector(ShopViewController.changeVerb), for: UIControlEvents.valueChanged)
        adjectiveSwitch.addTarget(self, action: #selector(ShopViewController.changeAdje), for: UIControlEvents.valueChanged)
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
    
    private func showConfirmAlert() {
        let alertController = UIAlertController(title: "パック欲しい？", message: "パック欲しい？欲しいの？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            self.getWordFromServer()
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getSelectedSpeech() -> Int {
        var type = 0
        
        if nounSwitch.isOn {
            type = 1
        } else if verbSwitch.isOn {
            type = 2
        } else {
            type = 3
        }

        return type
    }
    
    private func showCompletionAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        self.indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func getWordFromServer() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let url = URL(string: "http://taro.php.xdomain.jp/word2.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10.0
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
                "type": self.getSelectedSpeech(),
                "myWords": self.getMyWords(self.getSelectedSpeech())
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if error == nil {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[Int: String]] {
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
    
    private func getMyWords(_ type: Int) -> Array<String> {
        let myWords = WordManager.sharedManager.getWordByType(type: type)
        let wordStringArray = myWords.map({$0.word})
        return wordStringArray
    }
    
    private func saveWords(jsonResult: [[Int: String]]) {
        for (key, value) in jsonResult.flatMap({$0}) {
            WordManager.sharedManager.addWordToDB(type: key, word: value)
        }
    }
    
}
