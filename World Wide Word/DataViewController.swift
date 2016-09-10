//
//  DataViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class DataViewController: ViewController {
    var nounData: NSMutableArray = NSMutableArray()
    var verbData: NSMutableArray = NSMutableArray()
    var adjectiveData: NSMutableArray = NSMutableArray()
    var newWordData: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.segmentedControl.addTarget(self, action: "changeData:", forControlEvents: .ValueChanged)
        
        self.tableView.allowsSelection = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nounData.removeAllObjects()
        verbData.removeAllObjects()
        adjectiveData.removeAllObjects()
        newWordData.removeAllObjects()
        
        let dbhelper = DatabaseHelper()
        nounData.addObjectsFromArray(dbhelper.outputWord("名詞"))
        verbData.addObjectsFromArray(dbhelper.outputWord("動詞"))
        adjectiveData.addObjectsFromArray(dbhelper.outputWord("形容詞"))
        newWordData.addObjectsFromArray(dbhelper.outputWord("オリジナル"))
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return nounData.count
            case 1:
                return verbData.count
            case 2:
                return adjectiveData.count
            default:
                return newWordData.count
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor.clearColor()
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = nounData.objectAtIndex(indexPath.row) as? String
            case 1:
                cell.textLabel?.text = verbData.objectAtIndex(indexPath.row) as? String
            case 2:
                cell.textLabel?.text = adjectiveData.objectAtIndex(indexPath.row) as? String
            default:
                cell.textLabel?.text = newWordData.objectAtIndex(indexPath.row) as? String
            }

        return cell
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                removeData("名詞", wordData: nounData, indexPath: indexPath)
                
            case 1:
                removeData("動詞", wordData: verbData, indexPath: indexPath)
                
            case 2:
                removeData("形容詞", wordData: adjectiveData, indexPath: indexPath)
                
            default:
                removeData("オリジナル", wordData: newWordData, indexPath: indexPath)
            }
        }
    }
    
    func changeData(segment: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    func removeData(speech: String, wordData: NSMutableArray, indexPath: NSIndexPath!) {
        let alertController = UIAlertController(title: "削除", message: "削除しますか？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: { (action: UIAlertAction) -> Void in
            
            let dbhelper = DatabaseHelper()
            dbhelper.removeWord(speech, word: (wordData.objectAtIndex(indexPath.row) as? String)!)
            
            wordData.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)

        })
        let ngAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
        
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
