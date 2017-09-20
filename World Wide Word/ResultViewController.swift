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

class ResultViewController: ViewController {
    
    @IBOutlet weak var originalWordLabel: UILabel!
    @IBOutlet weak var bannerView3: GADBannerView!
    
    var originalWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalWordLabel.text = originalWord
        
        setAd()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveWord(_ sender: AnyObject) {
        let word = Word()
        word.speech = "オリジナル"
        word.text = originalWord
        
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
    
    // MARK: -Ad
    
    override func setAd() {
        bannerView3.adUnitID = "ca-app-pub-7727323242900759/9765737025"
        bannerView3.rootViewController = self
        bannerView3.load(GADRequest())
    }

}
