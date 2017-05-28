//
//  Window.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 03/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to change the weight and height in the storyboard for iphone4 to compact & compact 

import UIKit

@objc public class Window: UIWindow {
    
    override public var traitCollection: UITraitCollection {
        
        if DeviceType.isIPhone4 {
           // return UITraitCollection(traitsFromCollections: [UITraitCollection(horizontalSizeClass: .Compact), UITraitCollection(verticalSizeClass: .Compact)])
        }
        
        return super.traitCollection
    }
}
