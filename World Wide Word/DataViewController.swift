//
//  DataViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class DataViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
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
    
    func setAd() {
        bannerView.adUnitID = "ca-app-pub-7727323242900759/9765737025"
        bannerView.load(GADRequest())
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
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = WordManager.sharedManager.nounArray[(indexPath as NSIndexPath).row].text
            case 1:
                cell.textLabel?.text = WordManager.sharedManager.verbArray[(indexPath as NSIndexPath).row].text
            case 2:
                cell.textLabel?.text = WordManager.sharedManager.adjectiveArray[(indexPath as NSIndexPath).row].text
            default:
                cell.textLabel?.text = WordManager.sharedManager.originalArray[(indexPath as NSIndexPath).row].text
            }

        return cell
    }
    
    func tableView(_ tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.delete){
            removeWord(indexPath)
        }
    }
    
    @objc func changeDataList(_ segment: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func removeWord(_ indexPath: IndexPath!) {
        let alertController = UIAlertController(title: "削除", message: "削除しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: { (action: UIAlertAction) -> Void in
            var word = Word()
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                word = WordManager.sharedManager.nounArray[indexPath.row]
                WordManager.sharedManager.nounArray.remove(at: indexPath.row)
                
            case 1:
                word = WordManager.sharedManager.verbArray[indexPath.row]
                WordManager.sharedManager.verbArray.remove(at: indexPath.row)
                
            case 2:
                word = WordManager.sharedManager.adjectiveArray[indexPath.row]
                WordManager.sharedManager.adjectiveArray.remove(at: indexPath.row)
                
            default:
                word = WordManager.sharedManager.originalArray[indexPath.row]
                WordManager.sharedManager.originalArray.remove(at: indexPath.row)
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(word)
            }
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        })
        let ngAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(ngAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
