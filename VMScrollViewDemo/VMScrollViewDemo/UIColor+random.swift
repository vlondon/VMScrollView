//
//  UIColor+random.swift
//  VMScrollViewDemo
//
//  Created by Vladimirs Matusevics on 27/09/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func random() -> UIColor {
        let randomRed = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}
