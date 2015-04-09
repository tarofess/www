//
//  ResultViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class ResultViewController: ViewController {
    var newWord = ""
    
    @IBOutlet weak var newWordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        newWordLabel.text = newWord
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveWord(sender: AnyObject) {
        let dbhelper = DatabaseHelper()
        dbhelper.inputWordToDatabase(self.newWord, registerSpeech: "オリジナル")

        showCompleteAlert()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func showCompleteAlert() {
        let alertController = UIAlertController(title: "登録しました", message: "", preferredStyle: .Alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "はい", style: .Default, handler: { (action: UIAlertAction!) -> Void in self.dismissViewControllerAnimated(true, completion: nil) } )
        alertController.addAction(completeAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
