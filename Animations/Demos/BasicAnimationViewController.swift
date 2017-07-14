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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.0, animations: {
            // changes made in here will be animated
            self.square.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.square.alpha = 0.2
            self.square.backgroundColor = UIColor.blue
            self.square.transform = CGAffineTransform(scaleX: 3, y: 3)
        }) 
    }
    
}
