//
//  ViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 6/29/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var largerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    
    var viewExpaned = false
    
    @IBAction func animateButtonTapped(sender: AnyObject) {
        viewExpaned = !viewExpaned
        heightConstraint.active = !viewExpaned
        largerHeightConstraint.active = viewExpaned
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            for button in self.buttons {
                button.alpha = self.viewExpaned ? 1.0 : 0.0
            }
            
            self.arrowLabel.transform = self.viewExpaned ? CGAffineTransformMakeRotation(CGFloat(M_PI_2)) : CGAffineTransformMakeRotation(0)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
 
    @IBAction func transactionButtonTapped(sender: AnyObject) {
        var view = NSBundle.mainBundle().loadNibNamed("TransactionView", owner: self, options: nil)[0] as! UIView
        view.center = CGPointMake(-300, -300)
        self.view.addSubview(view)
        
        UIView.animateWithDuration(0.45, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
            view.center = self.view.center
        }, completion: nil)
        
        // 1
        let blurEffect = UIBlurEffect(style: .Light)
        // 2
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 3
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.insertSubview(blurView, atIndex: self.view.subviews.count-1)
                
        self.view.addConstraint(NSLayoutConstraint(item: blurView,
            attribute: .Height, relatedBy: .Equal,
            toItem: blurView.superview, attribute: .Height,
            multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: blurView,
            attribute: .Width, relatedBy: .Equal,
            toItem: blurView.superview, attribute: .Width,
            multiplier: 1, constant: 0))
    }
}
