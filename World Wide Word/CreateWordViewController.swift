//
//  CreateWordViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class CreateWordViewController: ViewController {
    
    @IBOutlet weak var adjective: UISwitch!
    
    @IBOutlet weak var noun: UISwitch!
    
    @IBOutlet weak var verb: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var resultViewController: ResultViewController = segue.destinationViewController as ResultViewController
        resultViewController.v = "a"
        
    }
    
    func judgeSpeechType() {
        
    }
    
}
