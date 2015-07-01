//
//  AdvancedConstraintViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 7/1/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class AdvancedConstraintViewController: UIViewController {

    @IBOutlet var initialConstraints: [NSLayoutConstraint]!
    @IBOutlet var finalConstraints: [NSLayoutConstraint]!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        for constraint in initialConstraints {
            constraint.active = false
        }
        
        for constraint in finalConstraints {
            constraint.active = true
        }
        
        UIView.animateWithDuration(1.0) {
            self.view.layoutIfNeeded()
        }
    }
}
