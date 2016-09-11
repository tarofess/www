//
//  DataViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class DataViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WordManager.sharedManager.getWordFromDB()
        
        tableView.allowsSelection = false
        segmentedControl.addTarget(self, action: #selector(DataViewController.changeDataList(_:)), forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                return WordManager.sharedManager.nounArray.count
            case 1:
                return WordManager.sharedManager.verbArray.count
            case 2:
                return WordManager.sharedManager.adjectiveArray.count
            default:
                return WordManager.sharedManager.originalArray.count
            }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = WordManager.sharedManager.nounArray[indexPath.row].text
            case 1:
                cell.textLabel?.text = WordManager.sharedManager.verbArray[indexPath.row].text
            case 2:
                cell.textLabel?.text = WordManager.sharedManager.adjectiveArray[indexPath.row].text
            default:
                cell.textLabel?.text = WordManager.sharedManager.originalArray[indexPath.row].text
            }

        return cell
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            removeWord(indexPath)
        }
    }
    
    func changeDataList(segment: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func removeWord(indexPath: NSIndexPath!) {
        let alertController = UIAlertController(title: "削除", message: "削除しますか？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "はい", style: .Default, handler: { (action: UIAlertAction) -> Void in
            var word = Word()
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                word = WordManager.sharedManager.nounArray[indexPath.row]
                WordManager.sharedManager.nounArray.removeAtIndex(indexPath.row)
                
            case 1:
                word = WordManager.sharedManager.verbArray[indexPath.row]
                WordManager.sharedManager.verbArray.removeAtIndex(indexPath.row)
                
            case 2:
                word = WordManager.sharedManager.adjectiveArray[indexPath.row]
                WordManager.sharedManager.adjectiveArray.removeAtIndex(indexPath.row)
                
            default:
                word = WordManager.sharedManager.originalArray[indexPath.row]
                WordManager.sharedManager.originalArray.removeAtIndex(indexPath.row)
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(word)
            }
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
        
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
