//
//  Putton.swift
//  Putton
//
//  Created by CHENCHIAN on 7/22/15.
//  Copyright (c) 2015 KICKERCHEN. All rights reserved.
//

import UIKit

struct PuttonConstants {
    static let defaultNearRadius: CGFloat = 110.0
    static let defaultEndRadius: CGFloat = 120.0
    static let defaultTimerInterval: Double = 0.036
    static let defaultExpandRotation: Double = M_PI * 2
    static let defaultCloseRotation: Double = M_PI * 4
    static let defaultAnimationDuration: Double = 0.5
    static let startButtonDefaultAnimationDuration: Double = 0.3
}

class Putton: UIButton, PuttonItemDelegate {

    var startButton: PuttonItem!
    var expandItems: NSArray! {
        didSet {
            self.setExpandItems()
        }
    }
    
    var expandRadius: CGFloat!
    var timer: NSTimer!
    var isAnimating = false
    var isExpand = false {
        didSet {
            
            // expand/close animation   
            if (self.timer == nil) {
                
                let selector = (self.isExpand) ? Selector("expandPuttonItems") : Selector("closePuttonItems")
                
                // Adding timer to runloop to make sure UI event won't block the timer from firing
                timer = NSTimer(timeInterval: PuttonConstants.defaultTimerInterval, target: self, selector: selector, userInfo: nil, repeats: false)
                NSRunLoop.currentRunLoop().addTimer(self.timer, forMode: NSRunLoopCommonModes)
                
                self.isAnimating = true
            }
        }
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, startItem: PuttonItem, expandItem: PuttonItem, itemCount: Int) {
    
        self.init(frame: frame)
     
        self.backgroundColor = UIColor.clearColor()
        self.expandRadius = 100
        
        // set startButton
        self.startButton = startItem
        self.startButton.delegate = self;
        self.startButton.center = CGPointMake(CGRectGetWidth(self.startButton.frame)/2.0, CGRectGetHeight(self.startButton.frame)/2.0)
        self.addSubview(self.startButton)
        
        // set expand items
        let items = NSMutableArray()
        for _ in 1...itemCount {
            items.addObject(expandItem.copy())
        }
        self.expandItems = items
        self.setExpandItems() // didSet is not called in initializer
    }
    
    func setExpandItems() {
        // clean
        for v in self.subviews {
            if v.tag >= 1000 {
                v.removeFromSuperview()
            }
        }
        
        for (var i = 0; i < self.expandItems.count; i++) {
            var item = expandItems[i] as! PuttonItem;
            item.tag = i + 1000;
            
            item.delegate = self
            let angle = 2.0 * CGFloat(M_PI) / CGFloat(self.expandItems.count)
            item.expandPoint = CGPointMake(self.startButton.center.x + self.expandRadius * sin(CGFloat(i) * angle), self.startButton.center.y + self.expandRadius * cos(CGFloat(i) * angle))
            item.center = self.startButton.center
            
            self.insertSubview(item, belowSubview: self.startButton)
        }
    }
    
    // MARK: -
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        // if animating, prevent touches
        if self.isAnimating == true {
            return false
        }
        
        // if not expand, only start button can be touched
        if self.isExpand == true {
            return true
        } else {
            return CGRectContainsPoint(self.startButton.frame, point)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        self.isExpand = !self.isExpand
    }
    

    // MARK: - PuttonItemDelegate methods

    func puttonItemTouchesBegan(item: PuttonItem) {
        
        if item == self.startButton {
            self.isExpand = !self.isExpand
        }
    }

    func puttonItemTouchesEnded(item: PuttonItem) {
        
        if item == self.startButton {
            return
        }
        
        // zoom the selected item
        UIView.animateWithDuration(PuttonConstants.defaultAnimationDuration, animations: {
        
            item.transform = CGAffineTransformMakeScale(10.0, 10.0)
            item.alpha = 0.0
            
            }, completion: {(finished) in
                
                item.transform = CGAffineTransformMakeScale(1.0, 1.0)
                item.center = self.startButton.center
                item.alpha = 1.0
                self.isExpand = !self.isExpand
        })
        
        // fade out other items
        for (var i = 0; i < self.expandItems.count; i++) {
            let otherItem = self.expandItems[i] as! PuttonItem
            if otherItem.tag == item.tag {
                continue
            }
            
            UIView.animateWithDuration(PuttonConstants.defaultAnimationDuration, animations: {
                
                otherItem.alpha = 0.0
                
                }, completion: {(finished) in
                    
                    otherItem.center = self.startButton.center
                    otherItem.alpha = 1.0
                    
                })
        }
    }
    
    
    func puttonItemAtIndex(index: Int) -> PuttonItem? {
        if index >= self.expandItems.count {
            return nil
        }
        return self.expandItems[index] as? PuttonItem
    }
    
    
    // MARK: - Animation methods
    
    
    func expandPuttonItems() {
        
        for (var i = 0; i < self.expandItems.count; i++) {
            let item = self.expandItems[i] as! PuttonItem
            UIView.animateWithDuration(PuttonConstants.defaultAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allZeros, animations: {
                
                item.transform = CGAffineTransformMakeRotation(CGFloat(PuttonConstants.defaultExpandRotation))
                item.center = item.expandPoint
                
                }, completion: nil)
        }
        
        self.isAnimating = false
        self.timer.invalidate()
        self.timer = nil
    }
    
    func closePuttonItems() {
        
        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.values = [NSNumber(double: 0.0), NSNumber(double: PuttonConstants.defaultCloseRotation), NSNumber(double: 0.0)]
        rotateAnimation.duration = PuttonConstants.defaultAnimationDuration
        rotateAnimation.keyTimes = [NSNumber(float: 0.0), NSNumber(float: 0.4), NSNumber(float: 0.5)]
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        for (var i = 0; i < self.expandItems.count; i++) {
            let item = self.expandItems[i] as! PuttonItem
            item.layer.addAnimation(rotateAnimation, forKey: "Close")
            
            UIView.animateWithDuration(PuttonConstants.defaultAnimationDuration, animations: {
                item.center = self.startButton.center
            })
        }

        self.isAnimating = false
        self.timer.invalidate()
        self.timer = nil
    }
}
