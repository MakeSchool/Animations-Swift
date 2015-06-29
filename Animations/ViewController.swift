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
    var blurView: UIView!
    var popupView: UIView!
    
    @IBAction func closeTransactionViewTapped(sender: AnyObject) {
        blurView.removeFromSuperview()
        popupView.removeFromSuperview()
    }
    
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
        popupView = NSBundle.mainBundle().loadNibNamed("TransactionView", owner: self, options: nil)[0] as! UIView
        popupView.center = CGPointMake(-300, -300)
        self.view.addSubview(popupView)
        
        let blurEffect = UIBlurEffect(style: .Light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.insertSubview(self.blurView, atIndex: self.view.subviews.count-1)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.blurView,
            attribute: .Width, relatedBy: .Equal,
            toItem: self.blurView.superview, attribute: .Width,
            multiplier: 1, constant: 0))
        
        self.view.layoutIfNeeded()
        
        self.view.addConstraint(NSLayoutConstraint(item: self.blurView,
            attribute: .Height, relatedBy: .Equal,
            toItem: self.blurView.superview, attribute: .Height,
            multiplier: 1, constant: 0))
        
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
            self.popupView.center = self.view.center
            self.view.layoutIfNeeded()
        }, completion: nil)
        
  
    }
}
