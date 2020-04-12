//
//  ShopViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ShopViewController: UIViewController {
    
    @IBOutlet weak var nounSwitch: UISwitch!
    @IBOutlet weak var verbSwitch: UISwitch!
    @IBOutlet weak var adjectiveSwitch: UISwitch!
    @IBOutlet weak var purchaseButton: UIButton!
    
    private var productPrice: String!
    private var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActivityIndicator()
        setSwitchAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setActivityIndicator() {
        indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.medium
        self.view.addSubview(indicator)
    }
    
    private func setSwitchAction() {
        nounSwitch.addTarget(self, action: #selector(ShopViewController.changeNoun), for: UIControl.Event.valueChanged)
        verbSwitch.addTarget(self, action: #selector(ShopViewController.changeVerb), for: UIControl.Event.valueChanged)
        adjectiveSwitch.addTarget(self, action: #selector(ShopViewController.changeAdje), for: UIControl.Event.valueChanged)
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
    
    private func getSelectedSpeech() -> (type: Int, speech: String) {
        var selectedSpeech: (Int, String)
        
        if nounSwitch.isOn {
            selectedSpeech = (1, "名詞")
        } else if verbSwitch.isOn {
            selectedSpeech = (2, "動詞")
        } else {
            selectedSpeech = (3, "形容詞")
        }

        return selectedSpeech
    }
    
    private func showCompletionAlert(_ title: String, message: String) {
        self.indicator.stopAnimating()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        nounSwitch.isUserInteractionEnabled = true
        verbSwitch.isUserInteractionEnabled = true
        adjectiveSwitch.isUserInteractionEnabled = true
        purchaseButton.isUserInteractionEnabled = true
    }
    
    private func getWordFromServer() {
        self.indicator.startAnimating()

        nounSwitch.isUserInteractionEnabled = false
        verbSwitch.isUserInteractionEnabled = false
        adjectiveSwitch.isUserInteractionEnabled = false
        purchaseButton.isUserInteractionEnabled = false
        
        let url = URL(string: "http://taro.php.xdomain.jp/getWords.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10.0
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
                "type": self.getSelectedSpeech().type,
                "myWords": self.getMyWords(self.getSelectedSpeech().type)
            ] as [String : Any]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    self.showCompletionAlert("エラー", message: error!.localizedDescription)
                    return
                }
                
                do {
                    guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]] else {
                        self.showCompletionAlert("エラー", message: "\(self.getSelectedSpeech().speech)パックをゲットだぜできませんでした")
                        return
                    }
                    
                    if jsonResult.count == 0 {
                        self.showCompletionAlert("エラー", message: "\(self.getSelectedSpeech().speech)パックが現在品切れでゲットだぜできませんでした")
                        return
                    }
                    
                    self.saveWords(jsonResult: jsonResult)
                    self.showCompletionAlert("ゲットだぜ！", message: "新しい\(self.getSelectedSpeech().speech)をゲットだぜしました")

                } catch {
                    self.showCompletionAlert("エラー", message: "\(self.getSelectedSpeech().speech)パックをゲットだぜできませんでした")
                }
            }
        }
        task.resume()
    }
    
    private func getMyWords(_ type: Int) -> Array<String> {
        let myWords = WordManager.sharedManager.getWordByType(type: type)
        let wordStringArray = myWords.map({$0.word})
        return Array(wordStringArray)
    }
    
    private func saveWords(jsonResult: [[String: Any]]) {
        for wordPack in jsonResult {
            var type = 0
            var word = ""
            
            for (key, value) in wordPack {
                if key == "type" { type = value as! Int }
                if key == "word" { word = value as! String }
            }
            WordManager.sharedManager.addWordToDB(type: type, word: word)
        }
    }
    
}
