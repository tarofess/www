//
//  ResultViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class ResultViewController: ViewController {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    
    var originalWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalWordLabel.text = originalWord
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveWord(sender: AnyObject) {
        let word = Word()
        word.speech = "オリジナル"
        word.text = originalWord
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(word)
        }
        
        WordManager.sharedManager.originalArray.append(word)
        NSNotificationCenter.defaultCenter().postNotificationName("InsertWord", object: self, userInfo: ["indexPath": WordManager.sharedManager.originalArray.count - 1])

        showCompleteAlert()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showCompleteAlert() {
        let alertController = UIAlertController(title: "保存しました", message: "", preferredStyle: .Alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil) } )
        alertController.addAction(completeAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
