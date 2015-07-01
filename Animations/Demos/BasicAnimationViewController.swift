//
//  BasicAnimationViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 7/1/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class BasicAnimationViewController: UIViewController {

    @IBOutlet weak var square: UIView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1.0) {
            // changes made in here will be animated
            self.square.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.square.alpha = 0.5
            self.square.transform = CGAffineTransformMakeScale(3, 3)
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.view.layoutIfNeeded()
        }
        
        self.view.layoutIfNeeded()
    }
    
}