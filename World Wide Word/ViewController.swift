//
//  ViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/09.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var speechPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    private let speechs = ["名詞", "動詞", "形容詞"]
    private var selectedSpeech = 1

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- picker

    func numberOfComponents(in pickerview1: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerview1: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speechs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speechs[row]
    }
    
    func pickerView(_ pickerview1: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSpeech = row + 1
    }
    
    // MARK:- textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK:- registerButton
    
    @IBAction func registerWord(_ sender: AnyObject) {
        if textField.text == "" {
            UIUtils.showSimpleAlert("エラー", message: "文字を入力してください", view: self)
            return
        }
        
        if (WordManager.sharedManager.isExistsSameData(type: selectedSpeech, word: textField.text!)) {
            UIUtils.showSimpleAlert("エラー", message: "同じ言葉が既に登録されています", view: self)
        } else {
            WordManager.sharedManager.addWordToDB(type: selectedSpeech, word: textField.text!)
            UIUtils.showSimpleAlert("登録しました", message: "", view: self)
            textField.text = ""
        }
    }
    
}

