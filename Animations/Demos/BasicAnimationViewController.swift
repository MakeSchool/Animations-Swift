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
            var transforms = CGAffineTransform(rotationAngle: CGFloat.pi)
            transforms = transforms.scaledBy(x: 3, y: 3)
            self.square.transform = transforms
            self.square.alpha = 0.2
            self.square.backgroundColor = UIColor.blue
        })
    }
    
}
