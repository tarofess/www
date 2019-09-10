//
//  UIUtils.swift
//  World Wide Word
//
//  Created by t-matsusaki on 2018/12/19.
//  Copyright © 2018年 taro. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    
    static func showSimpleAlert(_ title: String, message: String, view: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let completeAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(completeAction)
        
        view.present(alertController, animated: true, completion: nil)
    }

}
