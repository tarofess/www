//
//  FromLeftSegue.swift
//  World Wide Word
//
//  Created by taro on 2015/03/31.
//  Copyright (c) 2015年 taro. All rights reserved.
//

import Foundation
import UIKit

class FromLeftSegue: UIStoryboardSegue {
    
    override func perform() {
        var sourceViewController: UIViewController = self.sourceViewController as UIViewController
        var destinationViewController: UIViewController = self.destinationViewController as UIViewController
        
        sourceViewController.view.addSubview(destinationViewController.view)
        
        destinationViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            
            }) { (finished) -> Void in
                
                destinationViewController.view.removeFromSuperview()
                sourceViewController.presentViewController(destinationViewController, animated: false, completion: nil)
                
        }
        
//        let transition: CATransition = CATransition()
//        transition.duration = 0.4
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromLeft
    }
}