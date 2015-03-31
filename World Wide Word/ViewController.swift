//
//  ViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/09.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var speechPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var dataForSpeechPicker = ["名詞", "動詞", "形容詞"]
    var registerWordStore = ""
    var registerSpeech = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        registerSpeech = dataForSpeechPicker[row]
    }
    
    // MARK:- textField
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        registerWordStore = textField.text
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- registerButton
    
    @IBAction func registerWord(sender: AnyObject) {
        var alertController = UIAlertController(title: "登録します", message: "\(dataForSpeechPicker[0])：test", preferredStyle: .Alert)
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "はい",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
//                self.registerWordToDatabase()
        })
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "いいえ",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func registerWordToDatabase() {
        let realm = RLMRealm.defaultRealm()
        
        let word = Word()
        word.speech = registerSpeech
        word.word = registerWordStore
        
    }
}

