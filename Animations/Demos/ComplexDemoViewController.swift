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
    
    func startDragging(_ initalPosition: CGPoint) {
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
            if (!self.popupView.frame.intersects(self.view.frame)) {
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
    
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        if (recognizer.state == .began) {
            if (!popupView.frame.contains(recognizer.location(in: self.view))) {
                return
            }
            
            startDragging(recognizer.location(in: self.view))
        } else if (recognizer.state == .changed) {
            if (draggingPopup && attachmentBehavior != nil) {
                attachmentBehavior.anchorPoint = recognizer.location(in: self.view)
            }
        } else if (recognizer.state == .ended || recognizer.state == .cancelled) {
            if !(draggingPopup) {
                return
            }
            
            endDragging()
        }
    }
    
    
    // MARK: View State
    
    func toggleExpandMenu() {
        viewExpanded = !viewExpanded
        heightConstraint.isActive = !viewExpanded
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            for button in self.buttons {
                button.alpha = self.viewExpanded ? 1.0 : 0.0
            }
            
            self.arrowButton.transform = self.viewExpanded ? CGAffineTransform(rotationAngle: CGFloat.pi / 2) : CGAffineTransform(rotationAngle: 0)
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func presentTransaction() {
        // Add gesture recognizer to detect touches
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ComplexDemoViewController.handlePan(_:)))
        self.view.addGestureRecognizer(gestureRecognizer)
        
        // Present TransactionView (loaded from separate interface file)
        popupView = Bundle.main.loadNibNamed("TransactionView", owner: self, options: nil)?[0] as! UIView
        popupView.center = CGPoint(x: -300, y: -300)
        self.view.addSubview(popupView)
        
        // Load and add overlay view
        overlayView = UIView()
        overlayView.backgroundColor = UIColor.darkGray
        overlayView.alpha = 0.0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.insertSubview(overlayView, at: view.subviews.count-1)
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .width, relatedBy: .equal,
            toItem: overlayView.superview, attribute: .width,
            multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: overlayView,
            attribute: .height, relatedBy: .equal,
            toItem: overlayView.superview, attribute: .height,
            multiplier: 1, constant: 0))
        
        // Force Layout pass, so that adding of the background view is not animated
        view.layoutIfNeeded()
        
        // Animate popover onto screen, blend in overlay
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: { () -> Void in
            self.popupView.center = self.view.center
            self.overlayView.alpha = 0.85
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                self.snapBehavior = UISnapBehavior(item: self.popupView, snapTo: self.view.center)
                self.animator.addBehavior(self.snapBehavior)
        })
    }
    
    func hideTransaction() {
        popupView.removeFromSuperview()
        view.removeGestureRecognizer(gestureRecognizer)
        
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.overlayView.alpha = 0.0
            }, completion: { (Bool) -> Void in
                self.overlayView.removeFromSuperview()
        })
    }
    
    // MARK: Button Callbacks
    
    @IBAction func animateButtonTapped(_ sender: AnyObject) {
        toggleExpandMenu()
    }
 
    @IBAction func transactionButtonTapped(_ sender: AnyObject) {
        presentTransaction()
    }
    
    @IBAction func closeTransactionViewTapped(_ sender: AnyObject) {
        hideTransaction()
    }
}
