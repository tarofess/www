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
    var registerSpeechStore = "名詞"

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
        registerSpeechStore = dataForSpeechPicker[row]
    }
    
    // MARK:- textField
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        registerWordStore = textField.text
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- registerButton
    
    @IBAction func registerWord(sender: AnyObject) {
        if self.textField.text == "" {
            
        } else {
            
            let dbhelper = DatabaseHelper()
            dbhelper.inputWordToDatabase(self.registerWordStore, registerSpeech: self.registerSpeechStore)
            
            self.textField.text = ""
            
            showCompleteAlert()
        }
    }
    
    func showCompleteAlert() {
        let alertController = UIAlertController(title: "登録しました", message: "", preferredStyle: .Alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "はい", style: .Default, handler: nil)
        alertController.addAction(completeAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

