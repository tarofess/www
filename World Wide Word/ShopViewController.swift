////
////  ShopViewController.swift
////  World Wide Word
////
////  Created by taro on 2015/03/29.
////  Copyright (c) 2015年 taro. All rights reserved.
////
//
//import UIKit
//import StoreKit
//
//class ShopViewController: ViewController, SKProductsRequestDelegate {
//    
//    @IBOutlet weak var purchaseButton: UIButton!
//    
//    @IBOutlet weak var nounSwitch: UISwitch!
//    @IBOutlet weak var verbSwitch: UISwitch!
//    @IBOutlet weak var adjectiveSwitch: UISwitch!
//    
//    var purchasePrice = 0
//    var indicator: UIActivityIndicatorView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        purchaseButton.enabled = false
//        
//        nounSwitch.setOn(true, animated: true)
//        verbSwitch.setOn(false, animated: true)
//        adjectiveSwitch.setOn(false, animated: true)
//        
//        [nounSwitch .addTarget(self, action: #selector(ShopViewController.changeNoun), forControlEvents: UIControlEvents.ValueChanged)]
//        [verbSwitch .addTarget(self, action: #selector(ShopViewController.changeVerb), forControlEvents: UIControlEvents.ValueChanged)]
//        [adjectiveSwitch .addTarget(self, action: #selector(ShopViewController.changeAdje), forControlEvents: UIControlEvents.ValueChanged)]
//        
////        self.fetchAvailableProducts()
//        
//        indicator = UIActivityIndicatorView()
//        indicator.frame = CGRectMake(0, 0, 100, 100)
//        indicator.center = self.view.center
//        indicator.hidesWhenStopped = true
//        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.7 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            self.purchaseButton.enabled = true
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
////    func fetchAvailableProducts() {
////        let productID:NSSet = NSSet(object: "com.taro.WWW");
////        let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject> as Set<NSObject>);
////        productsRequest.delegate = self;
////        productsRequest.start();
////    }
//    
//    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
//        let count : Int = response.products.count
//        if (count>0) {
//            var validProducts = response.products
//            let validProduct: SKProduct = response.products[0] 
//            if (validProduct.productIdentifier == "com.taro.WWW") {
//                purchasePrice = validProduct.price.integerValue
//               
//            } else {
//                print(validProduct.productIdentifier)
//            }
//        } else {
//            print("nothing")
//        }
//    }
//
//    
//    func changeNoun() {
//        if nounSwitch.on {
//            verbSwitch.setOn(false, animated: true)
//            adjectiveSwitch.setOn(false, animated: true)
//        }
//    }
//    func changeVerb() {
//        nounSwitch.setOn(false, animated: true)
//        adjectiveSwitch.setOn(false, animated: true)
//    }
//    func changeAdje() {
//        nounSwitch.setOn(false, animated: true)
//        verbSwitch.setOn(false, animated: true)
//    }
//    
//    @IBAction func purchase(sender: AnyObject) {
//        showConfirmAlert()
//    }
//    
//    func showConfirmAlert() {
//        let alertController = UIAlertController(title: "\(purchasePrice)円", message: "\(judgeSpeechType(false))パックを購入しますか？", preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "はい", style: .Default, handler: {
//            (action: UIAlertAction) -> Void in
//                self.getDataFromServer()
//        })
//        let ngAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: nil)
//        
//        alertController.addAction(ngAction)
//        alertController.addAction(okAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    func purchased(words: [String]) {
//        PFPurchase.buyProduct("com.taro.WWW", block: { (error: NSError?) -> Void in
//            
//            if error != nil {
//                self.showPurchaseAlert("エラー", message: "Wordパックを購入することができません")
//                
//            } else {
//                let dbhelper = DatabaseHelper()
//                
//                for word in words {
//                    dbhelper.inputWordToDatabase(word, registerSpeech: self.judgeSpeechType(false))
//                }
//                
//                self.showPurchaseAlert("完了", message: "\(self.judgeSpeechType(false))パックを購入しました")
//            }
//            
//            self.indicator.stopAnimating()
//        })
//    }
//    
//    func judgeSpeechType(isForSql: Bool) -> String {
//        var speech = ""
//        
//        if nounSwitch.on {
//            speech = isForSql ? "'名詞'" : "名詞"
//        }
//        
//        if verbSwitch.on {
//            speech = isForSql ? "'動詞'" : "動詞"
//        }
//        
//        if adjectiveSwitch.on {
//            speech = isForSql ? "'形容詞'" : "形容詞"
//        }
//
//        return speech
//    }
//    
//    func showPurchaseAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: "はい", style: .Default, handler: nil)
//        
//        alertController.addAction(okAction)
//        
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    func getDataFromServer() {
//        let url = NSURL(string: "http://taro.php.xdomain.jp/word2.php")
//        let request = NSMutableURLRequest(URL: url!)
//        
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        var param: [String: AnyObject] = [
//            "speech": judgeSpeechType(true),
//            "words": postWord(judgeSpeechType(false))
//        ]
//        request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(param, options: [])
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//            if error != nil {
//                var result = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//                
//                let fullWord = result as String
//                var words = fullWord.characters.split { $0 == "," }.map { String($0) }
//                
//                print(words)
//                
//                if words.count < 30 {
//                    self.showPurchaseAlert("エラー", message: "現在購入できる\(self.judgeSpeechType(false))パックがありません")
//                    
//                    self.indicator.stopAnimating()
//
//                } else {
//                    self.purchased(words)
//                }
//                
//            } else {
//                let alertController = UIAlertController(title: "エラー", message: "エラーが発生しました", preferredStyle: .Alert)
//                let okAction = UIAlertAction(title: "はい", style: .Default, handler: nil)
//                
//                alertController.addAction(okAction)
//                
//                self.presentViewController(alertController, animated: true, completion: nil)
//            }
//        })
//        task.resume()
//        
//        self.indicator.startAnimating()
//        self.view.addSubview(self.indicator)
//    }
//    
//    func postWord(speech: String) -> Array<String> {
//        var wordArray: [String] = []
//        
//        let words = Word.objectsWhere("speech = %@", speech)
//        
//        for word in words {
//            if let wordStore = word as? Word {
//                wordArray.append(wordStore.word)
//            }
//        }
//        
//        return wordArray
//    }
//}
