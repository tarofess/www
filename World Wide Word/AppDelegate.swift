//
//  AppDelegate.swift
//  World Wide Word
//
//  Created by taro on 2015/03/09.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        Parse.setApplicationId("of65cqmtpjvcXmG8yOhC22BBpZ2djJiHgzjjZtaG", clientKey: "JYz7geJ8nbXU2tFD8qvVpBqgId3NSKeVSvSngjX8")
//        PFPurchase.addObserverForProduct("com.taro.WWW", block: { (transaction: SKPaymentTransaction!) -> Void in
//            // Do Something
//        })
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        if (!ud.boolForKey("isFirstLaunch")) {
            registerDefaultWord()
            ud.setBool(true, forKey: "isFirstLaunch")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerDefaultWord() {
        let nounArray = [createInitialWord("名詞", text: "海"),
                         createInitialWord("名詞", text: "ことわざ"),
                         createInitialWord("名詞", text: "エンターテイナー"),
                         createInitialWord("名詞", text: "出口"),
                         createInitialWord("名詞", text: "神様"),
                         createInitialWord("名詞", text: "ガム"),
                         createInitialWord("名詞", text: "ジョウロ"),
                         createInitialWord("名詞", text: "巻物"),
                         createInitialWord("名詞", text: "カレンダー"),
                         createInitialWord("名詞", text: "ふでばこ")]
        let verbArray = [createInitialWord("動詞", text: "動く"),
                         createInitialWord("動詞", text: "固まる"),
                         createInitialWord("動詞", text: "口ずさむ"),
                         createInitialWord("動詞", text: "倒れる"),
                         createInitialWord("動詞", text: "組み立てる"),
                         createInitialWord("動詞", text: "守る"),
                         createInitialWord("動詞", text: "落ちる"),
                         createInitialWord("動詞", text: "直す"),
                         createInitialWord("動詞", text: "思い出す"),
                         createInitialWord("動詞", text: "謝る")]
        let adjectiveArray = [createInitialWord("形容詞", text: "赤い"),
                              createInitialWord("形容詞", text: "長い"),
                              createInitialWord("形容詞", text: "優しい"),
                              createInitialWord("形容詞", text: "ささやかな"),
                              createInitialWord("形容詞", text: "斬新な"),
                              createInitialWord("形容詞", text: "おぞましい"),
                              createInitialWord("形容詞", text: "なれなれしい"),
                              createInitialWord("形容詞", text: "かわいい"),
                              createInitialWord("形容詞", text: "頼もしい"),
                              createInitialWord("形容詞", text: "好奇心旺盛な")]
        
        let realm = try! Realm()
        try! realm.write {
            for noun in nounArray {
                realm.add(noun)
            }
            for verb in verbArray {
                realm.add(verb)
            }
            for adjective in adjectiveArray {
                realm.add(adjective)
            }
        }
    }
    
    func createInitialWord(speech: String!, text: String!) -> Word {
        let word = Word()
        word.speech = speech
        word.text = text
        
        return word
    }

}

