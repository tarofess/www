//
//  ResultViewController.swift
//  World Wide Word
//
//  Created by taro on 2015/03/29.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ResultViewController: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var originalWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAd()
        originalWordLabel.text = originalWord
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setAd() {
        bannerView.load(GADRequest())
    }
    
    @IBAction func saveWord(_ sender: AnyObject) {
        let word = Word()
        word.type = 4
        word.word = originalWord
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(word)
        }
        
        WordManager.sharedManager.originalArray.append(word)
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "InsertWord"), object: self, userInfo: ["indexPath": WordManager.sharedManager.originalArray.count - 1])

        showCompleteAlert()
    }
    
    @IBAction func back(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showCompleteAlert() {
        let alertController = UIAlertController(title: "保存しました", message: "", preferredStyle: .alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in self.dismiss(animated: true, completion: nil) } )
        alertController.addAction(completeAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
