//
//  Directorio.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 01/05/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to show Directorio with a table

import UIKit
import MapKit


var Arra: [Deportivas] = []
var titulo = ""
var nombreLocacion = ""
var latitud = 0.0
var longitud = 0.0
var nombres = ""
var telefonos = ""
var direcciones = ""
var encargados = ""
var correos = ""
/*
 class Team{
 var id: Invar var name: NSString!
 var shortname: NSString!
 
 
 init(id: Int, name:NSString, shortname: NSString) {
 self.id = id
 self.name = name
 self.shortname = shortname
 
 }*/
class Directorio: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableviewDirectorio: UITableView!
    
    /*var names = ["Deportiva del Estado", "Centro de Estudios de la Salud", "Macrocentro CODE I", "Deportiva de San Miguel"]
    var telefono = ["01 477 711 0147", "01 477 711 0148", "01 477 772 1515", "7 15 26 71"]
    var direccion = ["Blvrd Adolfo López Mateos Ote 3301, Julián de Obregón, 37290 León, Gto",
                     "Blvrd Adolfo López Mateos Ote 3302, Julián de Obregón, 37291 León, Gto",
                     "Blvd. Juan Alonso de Torres, Leon I, 37235 León, Gto",
                     "Blvd. Juan José Torres Landa S/N, Col. Sta. Rita de los Naranjos"]*/
     var filtered:[Deportivas] = []
     var searchActive : Bool = false
    
    //show home
    @IBAction func leftButton(sender: AnyObject) {
        /*let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
        let centerNavController = UINavigationController(rootViewController: centerViewController)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.centerViewController = centerNavController*/
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        adddeportivas()
        searchBar.placeholder = "Nombre de Deportiva"
       // self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        // Do any additional setup after loading the view.
    }
    
    //hide the keyboard
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func adddeportivas(){
        let artwork = Deportivas(title: "Polideportivo",
                                 locationName: "Burocratas, Colonia Marfil, 36250 Guanajuato, Gto",
                                 discipline: "Deportiva",
                                 coordinate: CLLocationCoordinate2D(latitude: 20.994088, longitude: -101.279687),
                                 names:"Polideportivo",
                                 telefono: "Teléfono: (473) 7341720",
                                 direccion:"Burocratas Colonia Marfil, 36250 Guanajuato, Gto",
                                 correo: "kariascas@guanajuato.gob.mx",
                                 encargado:"Admin: Karla Arias Castellanos")
        let artwork2 = Deportivas(title: "Macrocentro Deportivo CODE 1",
                                  locationName: "Carretera Guanajuato-Dolores KM 2.5, Colonia Valenciana, 36020 Guanajuato, Gto",
                                  discipline: "Deportiva",
                                  coordinate: CLLocationCoordinate2D(latitude: 21.029736, longitude: -101.254744),
                                  names:"Macrocentro Deportivo CODE 1",
                                  telefono: "Teléfono: (473) 7324096",
                                  direccion: "Carretera Guanajuato-Dolores KM 2.5, Colonia Valenciana, 36020 Guanajuato, Gto",
                                  correo: "rsandovalm@guanajuato.gob.mx",
                                  encargado:"Admin: Juan Rúben Sandoval Mendoza")
        let artwork3 = Deportivas(title: "Macrocentro Deportivo CODE 2",
                                  locationName: "Carretera Guanajuato-Dolores KM 3.5, Colonia Valenciana, 36020 Guanajuato, Gto",
                                  discipline: "Deportiva",
                                  coordinate: CLLocationCoordinate2D(latitude: 21.143189, longitude: -101.254458),
                                  names:"Macrocentro Deportivo CODE 2",
                                  telefono: "Teléfono: (473) 7324096",
                                  direccion:"Carretera Guanajuato-Dolores KM 3.5, Colonia Valenciana, 36020 Guanajuato, Gto",
                                  correo: "rsandovalm@guanajuato.gob.mx",
                                  encargado:"Admin: Juan Rúben Sandoval Mendoza")
        let artwork4 = Deportivas(title: "Macrocentro Deportivo León 1",
                                  locationName: "Blvd. Juan Alonso de Torres, Colonia León 1, 37179 León, Gto",
                                  discipline: "Deportiva",
                                  coordinate: CLLocationCoordinate2D(latitude: 21.1432408, longitude: -101.640817),
                                  names:"Macrocentro Deportivo León 1",
                                  telefono: "Teléfono: (477) 7722399",
                                  direccion:"Blvd. Juan Alonso de Torres, Colonia León 1, 37179 León, Gto",
                                  correo: "mgamares@guanajuato.gob.mx",
                                  encargado:"Admin: José de Jesús Aranda Regalado")
        let artwork5 = Deportivas(title: "Centro Acuático Dolores Hidalgo",
                                  locationName: "Calzada de los Héroes, Fraccionamiento San Cristobal 37804 Dolores Hidalgo, Gto",
                                  discipline: "Deportiva",
                                  coordinate: CLLocationCoordinate2D(latitude: 21.160156, longitude: -100.917597),
                                  names:"Centro Acuático Dolores Hidalgo",
                                  telefono: "Teléfono  (477) 7722399",
                                  direccion:"Calzada de los Héroes, Fraccionamiento San Cristobal 37804 Dolores Hidalgo, Gto",
                                  correo: "profdavidanzo@gmail.com",
                                  encargado:"Admin: David Anzo")
        
        Arra.append(artwork)
        Arra.append(artwork2)
        Arra.append(artwork3)
        Arra.append(artwork4)
        Arra.append(artwork5)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return  Arra.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableviewDirectorio.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCellDirectorio
        //cell.titleLabel.text =  names[indexPath.row]
      //  cell.direccionLabel.text = direccion[indexPath.row]
      //  cell.telefonoLabel.text = telefono[indexPath.row]
        
        if(searchActive){
            cell.titleLabel.text =  filtered[indexPath.row].title
            cell.direccionLabel.text = filtered[indexPath.row].direccion
            cell.telefonoLabel.text = filtered[indexPath.row].telefono
        } else {
           cell.titleLabel.text =  Arra[indexPath.row].title
            cell.direccionLabel.text = Arra[indexPath.row].direccion
            cell.telefonoLabel.text = Arra[indexPath.row].telefono
            
        }
        
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        cell.selectedBackgroundView = v;
        
        
       
    
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       // print(indexPath.row)
        //print("hola")
       if(searchActive){
        let tite = filtered.map { $0.title }
        titulo = tite[indexPath.row]!
        let nombre = filtered.map { $0.locationName }
        nombreLocacion = nombre[indexPath.row]
        let lat = filtered.map { $0.coordinate.latitude}
        latitud = lat[indexPath.row]
        let long = filtered.map { $0.coordinate.longitude }
        longitud = long[indexPath.row]
        let nom = filtered.map { $0.names }
        nombres = nom[indexPath.row]!
        let tel = filtered.map { $0.telefono }
        telefonos = tel[indexPath.row]!
        let dire = filtered.map { $0.direccion }
        direcciones = dire[indexPath.row]!
        let corr = filtered.map { $0.correo }
        correos = corr[indexPath.row]!
        let enc = filtered.map { $0.encargado }
        encargados = enc[indexPath.row]!

       } else{
        let tite = Arra.map { $0.title }
        titulo = tite[indexPath.row]!
        let nombre = Arra.map { $0.locationName }
        nombreLocacion = nombre[indexPath.row]
        let lat = Arra.map { $0.coordinate.latitude}
        latitud = lat[indexPath.row]
        let long = Arra.map { $0.coordinate.longitude }
        longitud = long[indexPath.row]
        let nom = Arra.map { $0.names }
        nombres = nom[indexPath.row]!
        let tel = Arra.map { $0.telefono }
        telefonos = tel[indexPath.row]!
        let dire = Arra.map { $0.direccion }
        direcciones = dire[indexPath.row]!
        let corr = Arra.map { $0.correo }
        correos = corr[indexPath.row]!
        let enc = Arra.map { $0.encargado }
        encargados = enc[indexPath.row]!

        }
        
        
        
        
    }
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //searchActive = false;
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
            searchActive = false
            tableviewDirectorio.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
      /*  filtered = names.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        */
        self.filtered = Arra.filter({( aSpecies: Deportivas) -> Bool in
            // to start, let's just search by name
            return aSpecies.title!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
    
        
        if(filtered.count == 0){
            searchActive = false;
           // print("false")
        } else {
            searchActive = true;
            // print("true")
        }
        self.tableviewDirectorio.reloadData()
    }

 
 
    
    
}
