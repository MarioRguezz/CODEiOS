//
//  CellModelExercise.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 14/07/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import Foundation
import UIKit

public class CellModelExercise: NSObject {
    var ejercicio: String!
    var minutos: String!
    var calorias: String!
    var isOn: Bool!
    
    init(ejercicio: String, minutos: String, calorias: String, isOn: Bool) {
        self.ejercicio = ejercicio
        self.minutos = minutos
        self.calorias = calorias
        self.isOn = isOn
    }
}