//
//  ViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/09.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    
    @IBOutlet weak var speechPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var dataForSpeechPicker = ["名詞", "動詞", "形容詞"]
    var registerWordStore = ""
    var registerSpeechStore = "名詞"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        if (ud.objectForKey("isRegisterdDefaultWord") == nil) {
            registerDefaultWord()
        }
        
        ud.setBool(true, forKey: "isRegisterdDefaultWord")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerDefaultWord() {
        let dbhelper = DatabaseHelper()
        
        dbhelper.inputWordToDatabase("海", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("ことわざ", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("エンターテイナー", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("出口", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("神様", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("ガム", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("ジョウロ", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("巻物", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("カレンダー", registerSpeech: "名詞")
        dbhelper.inputWordToDatabase("ふでばこ", registerSpeech: "名詞")
        
        dbhelper.inputWordToDatabase("動く", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("固まる", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("口ずさむ", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("倒れる", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("組み立てる", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("守る", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("落ちる", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("直す", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("思い出す", registerSpeech: "動詞")
        dbhelper.inputWordToDatabase("謝る", registerSpeech: "動詞")
        
        dbhelper.inputWordToDatabase("赤い", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("長い", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("優しい", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("ささやかな", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("斬新な", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("おぞましい", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("なれなれしい", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("かわいい", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("頼もしい", registerSpeech: "形容詞")
        dbhelper.inputWordToDatabase("好奇心旺盛な", registerSpeech: "形容詞")
    }

    // MARK:- picker

    func numberOfComponentsInPickerView(pickerview1: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerview1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataForSpeechPicker.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dataForSpeechPicker[row]
    }
    
    func pickerView(pickerview1: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        registerSpeechStore = dataForSpeechPicker[row]
    }
    
    // MARK:- textField
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        registerWordStore = textField.text!
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- registerButton
    
    @IBAction func registerWord(sender: AnyObject) {
        if self.textField.text == "" {
            
        } else {
            
            if (!checkSameDataExists()) {
            
                let dbhelper = DatabaseHelper()
                dbhelper.inputWordToDatabase(self.registerWordStore, registerSpeech: self.registerSpeechStore)
                
                self.textField.text = ""
                
                showAlert("登録しました", message: "")
            } else {
                showAlert("エラー", message: "同じ言葉が既に登録されています")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "はい", style: .Default, handler: nil)
        alertController.addAction(completeAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func checkSameDataExists() -> Bool {
        let dbhelper = DatabaseHelper()
        let wordData = dbhelper.outputWord(registerSpeechStore)
        
        for word in wordData {
            if (registerWordStore == word) {
                return true
            }
        }
        
        return false
    }
}

