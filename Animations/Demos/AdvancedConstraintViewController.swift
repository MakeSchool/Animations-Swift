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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for constraint in initialConstraints {
            constraint.isActive = false
        }
        
        for constraint in finalConstraints {
            constraint.isActive = true
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
}
