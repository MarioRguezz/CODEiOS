//
//  Deportivas.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 03/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to set Deportivas in the map


import Foundation
import MapKit
import AddressBook

class Deportivas: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let names: String?
    let telefono: String?
    let direccion: String?
    let correo: String?
    let encargado: String?
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, names: String, telefono: String, direccion: String, correo: String, encargado:String) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.names = names
        self.telefono = telefono
        self.direccion = direccion
        self.correo  = correo
        self.encargado = encargado
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    
    
    func mapItem() -> MKMapItem {
        let addressDict = [String(kABPersonAddressStreetKey): self.subtitle as! AnyObject]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        
        return mapItem
    }
}

