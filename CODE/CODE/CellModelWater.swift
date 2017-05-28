//
//  CellModelWater.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera on 13/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import Foundation
import UIKit

public class CellModelWater: NSObject {
    var recipiente: String!
    var mlLabel: String!
    var isOn: Bool!
    
    init(recipiente: String, mlLabel: String, isOn: Bool) {
        self.recipiente = recipiente
        self.mlLabel = mlLabel
        self.isOn = isOn
    }
}