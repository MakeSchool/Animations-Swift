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
    var overlayView: UIView!
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
    var viewExpanded = false
    
    // MARK: View Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animator = UIDynamicAnimator(referenceView: view)
    }
    
    // MARK: Drag Handling
    
    func startDragging(initalPosition: CGPoint) {
        draggingPopup = true
        
        attachmentBehavior = UIAttachmentBehavior(
            item: popupView,
            attachedToAnchor: initalPosition
        )
        
        // clean up gravity behavior if it exists
        if gravityBehavior != nil {
            animator.removeBehavior(gravityBehavior)
            gravityBehavior = nil
        }
        
        attachmentBehavior.damping = 2
        attachmentBehavior.frequency = 10
        attachmentBehavior.length = 0
        attachmentBehavior.anchorPoint = initalPosition
        
        dynamicItemBehavior = UIDynamicItemBehavior(items: [popupView])
        
        dynamicItemBehavior.action = {() -> Void in
            if (!CGRectIntersectsRect(self.popupView.frame, self.view.frame)) {
                self.closeTransactionViewTapped(self)
                self.draggingPopup = false
                self.animator.removeAllBehaviors()
            }
        }
        
        animator.addBehavior(attachmentBehavior)
        animator.addBehavior(dynamicItemBehavior)
    }
    
    func endDragging() {
        animator.removeBehavior(attachmentBehavior)
        attachmentBehavior = nil
        
        let p1 = popupView.center
        let p2 = self.view.center
        let distance = hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y))
        
        if (distance > 50) {
            draggingPopup = false
            self.view.removeGestureRecognizer(gestureRecognizer)
            
            gravityBehavior = UIGravityBehavior(items: [popupView])
            animator.addBehavior(gravityBehavior)
            
            animator.removeBehavior(snapBehavior)
            snapBehavior = nil
        }
    }
    
    // MARK: Touch Handling
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .Began) {
            if (!CGRectContainsPoint(popupView.frame,recognizer.locationInView(self.view))) {
                return
            }
            
            startDragging(recognizer.locationInView(self.view))
        } else if (recognizer.state == .Changed) {
            if (draggingPopup) {
                attachmentBehavior.anchorPoint = recognizer.locationInView(self.view)
            }
        } else if (recognizer.state == .Ended || recognizer.state == .Cancelled) {
            if !(draggingPopup) {
                return
            }
            
            endDragging()
        }
    }
    
    
    // MARK: View State
    
    func toggleExpandMenu() {
        viewExpanded = !viewExpanded
        heightConstraint.active = !viewExpanded
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            for button in self.buttons {
                button.alpha = self.viewExpanded ? 1.0 : 0.0
            }
            
            self.arrowButton.transform = self.viewExpanded ? CGAffineTransformMakeRotation(CGFloat(M_PI_2)) : CGAffineTransformMakeRotation(0)
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func presentTransaction() {
        // Add gesture recognizer to detect touches
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Present TransactionView (loaded from separate interface file)
        popupView = NSBundle.mainBundle().loadNibNamed("TransactionView", owner: self, options: nil)[0] as! UIView
        popupView.center = CGPointMake(-300, -300)
        self.view.addSubview(popupView)
        
        // Load and add overlay view
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.darkGrayColor()
        overlayView.alpha = 0.0
        overlayView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.insertSubview(overlayView, atIndex: view.subviews.count-1)
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .Width, relatedBy: .Equal,
            toItem: overlayView.superview, attribute: .Width,
            multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .Height, relatedBy: .Equal,
            toItem: overlayView.superview, attribute: .Height,
            multiplier: 1, constant: 0))
        
        // Force Layout pass, so that adding of the background view is not animated
        view.layoutIfNeeded()
        
        // Animate popover onto screen, blend in overlay
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
            self.popupView.center = self.view.center
            self.overlayView.alpha = 0.85
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                self.snapBehavior = UISnapBehavior(item: self.popupView, snapToPoint: self.view.center)
                self.animator.addBehavior(self.snapBehavior)
        })
    }
    
    func hideTransaction() {
        popupView.removeFromSuperview()
        view.removeGestureRecognizer(gestureRecognizer)
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.overlayView.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.overlayView.removeFromSuperview()
        })
    }
    
    // MARK: Button Callbacks
    
    @IBAction func animateButtonTapped(sender: AnyObject) {
        toggleExpandMenu()
    }
 
    @IBAction func transactionButtonTapped(sender: AnyObject) {
        presentTransaction()
    }
    
    @IBAction func closeTransactionViewTapped(sender: AnyObject) {
        hideTransaction()
    }
}
