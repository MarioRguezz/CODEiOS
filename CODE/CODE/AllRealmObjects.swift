//
//  AllRealmObjects.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 27/05/16.
//  Copyright © 2016 CODE. All rights reserved.
// Object with the framework Realm
// Bitacora is used in Ejercicio, Agua and Reportes

import Foundation
import RealmSwift

class Bitacora : Object{
    
    dynamic var id = 0
    dynamic var id_app_login = ""
    dynamic var fecha = ""
    dynamic var minutos_ejercicio: Int = 0
    dynamic var registro_agua: Double = 0.0
    dynamic var calorias_ejercicio: Int = 0
}

class Evento : Object{
    
    dynamic var id_evento = 0
    dynamic var titulo = ""
    dynamic var descripcion = ""
    dynamic var fecha_inicio = NSDate()
    dynamic var fecha_fin = NSDate()
    dynamic var fecha_actualizacion = NSDate()
    dynamic var fecha_inicioc = NSDate()
    dynamic var fecha_finc = NSDate()
    dynamic var tipo = 0
    dynamic var esLocal = false
    dynamic var estado = 0
    
   }
