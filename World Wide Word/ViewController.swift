//
//  ViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/09.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var speechPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let speechArray = ["名詞", "動詞", "形容詞"]
    var speech = "名詞"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
        WordManager.sharedManager.getWordFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAd() {
        bannerView.adUnitID = "ca-app-pub-7727323242900759/9765737025" 
        bannerView.load(GADRequest())
    }

    // MARK:- picker

    func numberOfComponentsInPickerView(_ pickerview1: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerview1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speechArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return speechArray[row]
    }
    
    func pickerView(_ pickerview1: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        speech = speechArray[row]
    }
    
    // MARK:- textField
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK:- registerButton
    
    @IBAction func registerWord(_ sender: AnyObject) {
        if textField.text == "" {
            showAlert("エラー", message: "文字を入力してください")
        } else {
            if (!checkSameDataExists()) {
                let word = Word()
                word.speech = speech
                word.text = textField.text!
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(word)
                }
                
                appendWordToArray(word)
                
                showAlert("登録しました", message: "")
                textField.text = ""
            } else {
                showAlert("エラー", message: "同じ言葉が既に登録されています")
            }
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "はい", style: .default, handler: nil)
        alertController.addAction(completeAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkSameDataExists() -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "speech = %@ AND text = %@", speech, textField.text!)
        let words = realm.objects(Word.self).filter(predicate)
        
        if words.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func appendWordToArray(_ word: Word) {
        if word.speech == "名詞" {
            WordManager.sharedManager.nounArray.append(word)
        } else if word.speech == "動詞" {
            WordManager.sharedManager.verbArray.append(word)
        } else {
            WordManager.sharedManager.adjectiveArray.append(word)
        }
    }
    
}

