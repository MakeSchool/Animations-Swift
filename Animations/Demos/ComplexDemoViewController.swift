//
//  ViewController.swift
//  Animations
//
//  Created by Benjamin Encz on 6/29/15.
//  Copyright (c) 2015 Benjamin Encz. All rights reserved.
//

import UIKit

class ComplexDemoViewController: UIViewController {

    // IBOutlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    // View References
    var blurView: UIView!
    var popupView: UIView!
    
    // UIKit Dynamics
    var snapBehavior : UISnapBehavior!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var gestureRecognizer: UIPanGestureRecognizer!
    var gravityBehavior: UIGravityBehavior!

    // View State
    var draggingPopup = false
    var viewExpaned = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
    }
    
    @IBAction func closeTransactionViewTapped(sender: AnyObject) {
        popupView.removeFromSuperview()
        self.view.removeGestureRecognizer(gestureRecognizer)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.blurView.alpha = 0.0
        }, completion: { (Bool) -> Void in
            self.blurView.removeFromSuperview()
        })
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
            
            dynamicItemBehavior.action = {() -> Void in
                if (!CGRectIntersectsRect(self.popupView.frame, self.view.frame)) {
                    self.closeTransactionViewTapped(self)
                    self.draggingPopup = false
                    self.animator.removeAllBehaviors()
                }
            }
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
                draggingPopup = false
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
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            
            for button in self.buttons {
                button.alpha = self.viewExpaned ? 1.0 : 0.0
            }
            
            self.arrowButton.transform = self.viewExpaned ? CGAffineTransformMakeRotation(CGFloat(M_PI_2)) : CGAffineTransformMakeRotation(0)
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
