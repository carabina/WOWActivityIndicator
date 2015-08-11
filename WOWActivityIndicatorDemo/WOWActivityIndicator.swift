//
//  WOWActivityIndicator.swift
//  WOWActivityIndicatorDemo
//
//  Created by Zhou Hao on 11/08/15.
//  Copyright © 2015年 Zeus. All rights reserved.
//

import UIKit

@IBDesignable
public class WOWActivityIndicator: UIView {
    
    // MARK: private member variables
    let kMarkerAnimationKey = "MarkerAnimationKey"
    var marker : CALayer!
    var spinnerReplicator : CAReplicatorLayer!
    
    // MARK: Inspectable variables
    @IBInspectable public var markerCount : Int = 6 {

        didSet {
            if markerCount < 6 {
                markerCount = 6
            }
        }
    }
    
    @IBInspectable public var cornerRadius : CGFloat = 5.0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable public var thickness : CGFloat = 16.0
    @IBInspectable public var length  : CGFloat = 24.0
    @IBInspectable public var duration : Double = 1.0
    @IBInspectable public var padding : CGFloat = 5.0

#if !TARGET_INTERFACE_BUILDER
    // This called before properties setup in IB
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
      // This called before properties setup in IB so that I won't use it
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

#endif
    
    public override func awakeFromNib() {
        
        setup()
    }
    
    // This will be called in build time in IB so that it will be shown correctly
    // in storyboard
    public override func prepareForInterfaceBuilder() {
        
        setup()
    }
    
    func setup() {
        
        marker = CALayer()
        let radius = min(self.frame.width,self.frame.height)/2
        
        marker.bounds = CGRectMake(0, 0, thickness, length)
        marker.cornerRadius = thickness*0.5
        marker.backgroundColor = tintColor.CGColor
        
        marker.position = CGPointMake(self.bounds.width*0.5,self.bounds.height*0.5 + radius - length - padding)

        spinnerReplicator = CAReplicatorLayer()
        spinnerReplicator.bounds = self.bounds
        spinnerReplicator.position = CGPointMake(self.frame.width/CGFloat(2),self.frame.height/CGFloat(2))
        
        let angle = CGFloat(2.0*M_PI)/CGFloat(markerCount)
        let instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        
        spinnerReplicator.instanceCount = markerCount
        spinnerReplicator.instanceTransform = instanceRotation

        spinnerReplicator.addSublayer(marker)
        self.layer.addSublayer(spinnerReplicator)
        
    }
    
    public func startAnimation() {
        
        marker.opacity = 0
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 1.0
        fade.toValue = 0.0
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        fade.repeatCount = Float.infinity
        fade.duration = duration
        
        let markerAnimationDuration = duration/Double(markerCount)
        spinnerReplicator.instanceDelay = markerAnimationDuration
        marker.addAnimation(fade, forKey: kMarkerAnimationKey)
        
    }
    
    public func stopAnimation() {
        
        marker.removeAllAnimations()        
    }

}