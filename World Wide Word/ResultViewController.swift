//
//  ResultViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: UIViewController {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    
    var originalWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setResult()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setResult() {
        originalWordLabel.text = originalWord
    }
    
    @IBAction func saveWord(_ sender: AnyObject) {
        if (!WordManager.sharedManager.isExistsSameData(type: 4, word: originalWord)) {
            WordManager.sharedManager.addWordToDB(type: 4, word: originalWord)
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "InsertWord"), object: self, userInfo: ["indexPath": WordManager.sharedManager.originalArray.count - 1])
            showResultSaveCompleteAlert()
        } else {
            UIUtils.showSimpleAlert("エラー", message: "同じ言葉が既に登録されています", view: self)
        }
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showResultSaveCompleteAlert() {
        let alertController = UIAlertController(title: "保存しました", message: "", preferredStyle: .alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in self.dismiss(animated: true, completion: nil) } )
        alertController.addAction(completeAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
