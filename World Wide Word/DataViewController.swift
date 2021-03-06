//
//  DataViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        segmentedControl.addTarget(self, action: #selector(DataViewController.changeDataList(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = WordManager.sharedManager.nounArray[(indexPath as NSIndexPath).row].word
            case 1:
                cell.textLabel?.text = WordManager.sharedManager.verbArray[(indexPath as NSIndexPath).row].word
            case 2:
                cell.textLabel?.text = WordManager.sharedManager.adjectiveArray[(indexPath as NSIndexPath).row].word
            default:
                cell.textLabel?.text = WordManager.sharedManager.originalArray[(indexPath as NSIndexPath).row].word
            }

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete){
            removeWord(indexPath)
        }
    }
    
    @objc func changeDataList(_ segment: UISegmentedControl) {
        tableView.reloadData()
    }
    
    private func removeWord(_ indexPath: IndexPath!) {
        let alertController = UIAlertController(title: "削除", message: "削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) -> Void in
            var word = Word()
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                word = WordManager.sharedManager.nounArray[indexPath.row]
                
            case 1:
                word = WordManager.sharedManager.verbArray[indexPath.row]
                
            case 2:
                word = WordManager.sharedManager.adjectiveArray[indexPath.row]
                
            default:
                word = WordManager.sharedManager.originalArray[indexPath.row]
            }
            
            WordManager.sharedManager.removeWordFromDB(word: word)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
