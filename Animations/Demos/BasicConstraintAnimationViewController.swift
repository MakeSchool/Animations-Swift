//
//  BasicConstraintAnimationViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 7/1/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class BasicConstraintAnimationViewController: UIViewController {

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animateWithDuration(1.0) {
            self.widthConstraint.constant = 400
            // changes made in here will be animated
            self.view.layoutIfNeeded()
        }
    }
    
}
