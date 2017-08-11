//
//  UIColor+Extension.swift
//  TearBud
//
//  Created by Dimitar Dragiev on 10/6/16.
//  Copyright © 2016 Path Finder. All rights reserved.
//

import UIKit

public extension UIColor {
    
    public static func RGB(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    public static func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
}
