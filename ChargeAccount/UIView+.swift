//
//  UIView+.swift
//  MRS
//
//  Created by wd on 2022/5/9.
//

import Foundation
import UIKit

extension UIView {
    
    func shakeIt(_ duration: CFTimeInterval = 0.35) {
        
        self.layer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 5, -5, 5, 0]
        animation.keyTimes = [0.0, NSNumber(value: (1 / 6.0)), NSNumber(value: (3 / 6.0)), NSNumber(value: (5 / 6.0)), 1.0]
        animation.duration = 0.35
        animation.isAdditive = true
        
        self.layer.add(animation, forKey: "shake")
    }
}

