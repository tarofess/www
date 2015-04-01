//
//  ResultViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class ResultViewController: ViewController {
    var v = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        println(v)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveWord(sender: AnyObject) {
        var alertController = UIAlertController(title: "登録しました", message: "", preferredStyle: .Alert)
        
        let saveAction:UIAlertAction = UIAlertAction(title: "はい",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                    self.registerCreatedWordToDatabase()
        })
        
        alertController.addAction(saveAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerCreatedWordToDatabase() {
        
    }
}
