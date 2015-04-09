//
//  DataViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit

class DataViewController: ViewController {
    var nounData: [String] = []
    var verbData: [String] = []
    var adjectiveData: [String] = []
    var newWordData: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.segmentedControl.addTarget(self, action: "changeData:", forControlEvents: .ValueChanged)
        
        let dbhelper = DatabaseHelper()
        nounData = dbhelper.outputWord("名詞")
        verbData = dbhelper.outputWord("動詞")
        adjectiveData = dbhelper.outputWord("形容詞")
        newWordData = dbhelper.outputWord("オリジナル")
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
    
    //セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor.clearColor()
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = nounData[indexPath.row]
            case 1:
                cell.textLabel?.text = verbData[indexPath.row]
            case 2:
                cell.textLabel?.text = adjectiveData[indexPath.row]
            default:
                cell.textLabel?.text = newWordData[indexPath.row]
            }

        return cell
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!){
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                nounData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                let dbhelper = DatabaseHelper()
                dbhelper.removeWord("名詞", id: indexPath.row)
                
            case 1:
                verbData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                let dbhelper = DatabaseHelper()
                dbhelper.removeWord("動詞", id: indexPath.row)
                
            case 2:
                adjectiveData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                let dbhelper = DatabaseHelper()
                dbhelper.removeWord("形容詞", id: indexPath.row)
                
            default:
                newWordData.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                let dbhelper = DatabaseHelper()
                dbhelper.removeWord("オリジナル", id: indexPath.row)
            }
        }
    }
    
    func changeData(segment: UISegmentedControl) {
        self.tableView.reloadData()
    }
}
