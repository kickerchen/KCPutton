//
//  PuttonItem.swift
//  Putton
//
//  Created by CHENCHIAN on 7/22/15.
//  Copyright (c) 2015 KICKERCHEN. All rights reserved.
//

import UIKit

protocol PuttonItemDelegate {
    func puttonItemTouchesBegan(item: PuttonItem);
    func puttonItemTouchesEnded(item:PuttonItem);
}

class PuttonItem: UIButton, NSCopying {

    var delegate: PuttonItemDelegate?
    var expandPoint: CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("Not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage) {
        
        self.init(frame: CGRectMake(0, 0, image.size.width, image.size.height))
        
        setImage(image, forState: .Normal)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = PuttonItem(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        
        if let myImageView = self.imageView {
            if let myImage = myImageView.image {
                copy.setImage(myImageView.image, forState: .Normal)
            }
        }
        
        return copy
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        // pop animation
        self.transform = CGAffineTransformMakeScale(0.8, 0.8)
        UIView.animateWithDuration(PuttonConstants.startButtonDefaultAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.allZeros, animations: {
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            
            }, completion: nil)
        
        self.delegate?.puttonItemTouchesBegan(self)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {

        self.delegate?.puttonItemTouchesEnded(self)
    }
}
