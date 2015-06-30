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
    var snapBehavior : UISnapBehavior!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var gestureRecognizer: UIPanGestureRecognizer!
    var gravityBehavior: UIGravityBehavior!
    var draggingPopup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
    }
    
    @IBAction func closeTransactionViewTapped(sender: AnyObject) {
        blurView.removeFromSuperview()
        popupView.removeFromSuperview()
        self.view.removeGestureRecognizer(gestureRecognizer)
    }
    
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .Began) {
            if (!CGRectContainsPoint(popupView.frame,recognizer.locationInView(self.view))) {
                return
            }
            
            draggingPopup = true
            
            attachmentBehavior = UIAttachmentBehavior(
                item: popupView,
                attachedToAnchor: recognizer.locationInView(self.view)
            )
            
            attachmentBehavior.damping = 2
            attachmentBehavior.frequency = 10
            attachmentBehavior.length = 0
            attachmentBehavior.anchorPoint = recognizer.locationInView(self.view)
            animator.addBehavior(attachmentBehavior)
            dynamicItemBehavior = UIDynamicItemBehavior(items: [popupView])
            animator.addBehavior(dynamicItemBehavior)
        } else if (recognizer.state == .Changed) {
            if (draggingPopup) {
                attachmentBehavior.anchorPoint = recognizer.locationInView(self.view)
            }
        } else if (recognizer.state == .Ended || recognizer.state == .Cancelled) {
            if !(draggingPopup) {
                return
            }
            
            animator.removeBehavior(attachmentBehavior)
            attachmentBehavior = nil
            
            let p1 = popupView.center
            let p2 = self.view.center
            let distance = hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y))
            
            if (distance > 50) {
                gravityBehavior = UIGravityBehavior(items: [popupView])
                animator.addBehavior(gravityBehavior)
                
                animator.removeBehavior(snapBehavior)
                snapBehavior = nil
                self.view.removeGestureRecognizer(gestureRecognizer)
            }
        }
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
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        popupView = NSBundle.mainBundle().loadNibNamed("TransactionView", owner: self, options: nil)[0] as! UIView
        popupView.center = CGPointMake(-300, -300)
        self.view.addSubview(popupView)
        
        let blurEffect = UIBlurEffect(style: .Light)
        blurView = UIView()
        blurView.backgroundColor = UIColor.darkGrayColor()
        blurView.alpha = 0.0
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.insertSubview(self.blurView, atIndex: self.view.subviews.count-1)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.blurView,
            attribute: .Width, relatedBy: .Equal,
            toItem: self.blurView.superview, attribute: .Width,
            multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.blurView,
            attribute: .Height, relatedBy: .Equal,
            toItem: self.blurView.superview, attribute: .Height,
            multiplier: 1, constant: 0))

        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
            self.popupView.center = self.view.center
            self.blurView.alpha = 0.85
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                self.snapBehavior = UISnapBehavior(item: self.popupView, snapToPoint: self.view.center)
                self.animator.addBehavior(self.snapBehavior)
        })
    }
}
