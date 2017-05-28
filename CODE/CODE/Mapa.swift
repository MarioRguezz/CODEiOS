//
//  Mapa.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez & Oscar Barrera Casillas on 03/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//

import UIKit
import MapKit

class Mapa: UIViewController {
    
    let regionRadius: CLLocationDistance = 1000
    
    
    @IBOutlet weak var titless: UILabel!
    @IBOutlet weak var direccion: UITextView!
    @IBOutlet weak var telefono: UILabel!
    @IBOutlet weak var correo: UILabel!
    @IBOutlet weak var encargado: UILabel!
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titless.text = titulo
        direccion.text = direcciones
        telefono.text = telefonos
        correo.text = correos
        encargado.text = encargados
        let initialLocation = CLLocation(latitude: latitud, longitude: longitud)
        centerMapOnLocation(initialLocation)
        let artwork = Deportivas(title: titulo,
                              locationName: nombreLocacion,
                              discipline: "Deportiva",
                              coordinate: CLLocationCoordinate2D(latitude: latitud, longitude: longitud),
                              names: nombres,
                              telefono: telefonos,
                              direccion: direcciones,
                              correo: correos,
                              encargado: encargados)
        
      mapView.addAnnotation(artwork)
      // print(nombres)
        //  mapView.delegate = self Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

