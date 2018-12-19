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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let ud = UserDefaults.standard
        
        if (!ud.bool(forKey: "isFirstLaunch")) {
            registerDefaultWord()
            ud.set(true, forKey: "isFirstLaunch")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerDefaultWord() {
        let nounArray = [createInitialWord(1, text: "海"),
                         createInitialWord(1, text: "ことわざ"),
                         createInitialWord(1, text: "エンターテイナー"),
                         createInitialWord(1, text: "出口"),
                         createInitialWord(1, text: "神様"),
                         createInitialWord(1, text: "ガム"),
                         createInitialWord(1, text: "ジョウロ"),
                         createInitialWord(1, text: "巻物"),
                         createInitialWord(1, text: "カレンダー"),
                         createInitialWord(1, text: "ふでばこ")]
        let verbArray = [createInitialWord(2, text: "動く"),
                         createInitialWord(2, text: "固まる"),
                         createInitialWord(2, text: "口ずさむ"),
                         createInitialWord(2, text: "倒れる"),
                         createInitialWord(2, text: "組み立てる"),
                         createInitialWord(2, text: "守る"),
                         createInitialWord(2, text: "落ちる"),
                         createInitialWord(2, text: "直す"),
                         createInitialWord(2, text: "思い出す"),
                         createInitialWord(2, text: "謝る")]
        let adjectiveArray = [createInitialWord(3, text: "赤い"),
                              createInitialWord(3, text: "長い"),
                              createInitialWord(3, text: "優しい"),
                              createInitialWord(3, text: "ささやかな"),
                              createInitialWord(3, text: "斬新な"),
                              createInitialWord(3, text: "おぞましい"),
                              createInitialWord(3, text: "なれなれしい"),
                              createInitialWord(3, text: "かわいい"),
                              createInitialWord(3, text: "頼もしい"),
                              createInitialWord(3, text: "好奇心旺盛な")]
        
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
    
    func createInitialWord(_ type: Int, text: String) -> Word {
        let word = Word()
        word.type = type
        word.word = text
        
        return word
    }

}

