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
 
}
